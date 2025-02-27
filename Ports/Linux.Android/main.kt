package com.example.flipentui

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.google.common.util.concurrent.ListenableFuture
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { FlipentApp() }
    }
}

@Composable
fun FlipentApp() {
    var selectedTab by remember { mutableStateOf("Scan Card") }
    var resumePattern by remember { mutableStateOf("") }

    Column(modifier = Modifier.fillMaxSize()) {
        TabRow(selectedTabIndex = listOf("Scan Card", "Input Bits", "About").indexOf(selectedTab)) {
            listOf("Scan Card", "Input Bits", "About").forEach { tab ->
                Tab(
                        text = { Text(tab) },
                        selected = selectedTab == tab,
                        onClick = { selectedTab = tab }
                )
            }
        }
        when (selectedTab) {
            "Scan Card" -> ScanCardView { scannedText -> resumePattern = scannedText }
            "Input Bits" -> InputBitsView(resumePattern, onPatternChange = { resumePattern = it })
            "About" -> AboutView()
        }
    }
}

@Composable
fun ScanCardView(onScanComplete: (String) -> Unit) {
    val context = LocalContext.current
    val cameraExecutor: ExecutorService = Executors.newSingleThreadExecutor()
    val lifecycleOwner = LocalContext.current as LifecycleOwner

    LaunchedEffect(Unit) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) !=
                        PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                    context as ComponentActivity,
                    arrayOf(Manifest.permission.CAMERA),
                    0
            )
        }
    }

    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        AndroidView(
                factory = { ctx ->
                    val cameraProviderFuture: ListenableFuture<ProcessCameraProvider> =
                            ProcessCameraProvider.getInstance(ctx)
                    cameraProviderFuture.get().let { cameraProvider ->
                        val imageAnalyzer =
                                ImageAnalysis.Builder().build().also {
                                    it.setAnalyzer(cameraExecutor) { imageProxy ->
                                        val result = analyzeImage(imageProxy)
                                        onScanComplete(result)
                                        imageProxy.close()
                                    }
                                }
                        cameraProvider.bindToLifecycle(
                                lifecycleOwner,
                                androidx.camera.core.CameraSelector.DEFAULT_BACK_CAMERA,
                                imageAnalyzer
                        )
                    }
                },
                modifier = Modifier.fillMaxSize()
        )
    }
}

fun analyzeImage(image: ImageProxy): String {
    Log.d("Scan", "Image analyzed")
    return "Detected Pattern"
}

@Composable
fun InputBitsView(pattern: String, onPatternChange: (String) -> Unit) {
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally) {
        TextField(
                value = pattern,
                onValueChange = onPatternChange,
                label = { Text("Enter Resume-Pattern") }
        )
        Spacer(modifier = Modifier.height(16.dp))
        Text("Parsed Pattern: $pattern")
    }
}

@Composable
fun AboutView() {
    Box(
            modifier = Modifier.fillMaxSize().background(Color.LightGray),
            contentAlignment = Alignment.Center
    ) { Text("Flipent UI - A tool for interpreting MCO Punch Cards.") }
}
