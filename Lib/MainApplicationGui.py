import tkinter as tk
from tkinter import messagebox
import numpy as np

MCO_VERSIONS = {
    "63B": (6, 3),
    "75B": (8, 4),
    "182B": (12, 6)
}

def parse_resume_pattern(pattern, rows, cols):
    """Parses a Flipent resume-pattern and converts it into a punch card grid."""
    grid = np.zeros((rows, cols), dtype=str)
    grid[:] = '.'  # Default empty cell
    
    for entry in pattern.split(', '):
        symbol, coords = entry[0], entry[1:]
        row, col = int(coords[0]), int(coords[1])
        
        if row < rows and col < cols:
            if symbol == '@':
                grid[row, col] = 'X'  # Full-bit flip
            elif symbol == '#':
                grid[row, col] = '/'  # Half-bit flip
    
    return grid

def display_punch_card(grid):
    """Displays the punch card grid in a readable format."""
    for row in grid:
        print(' '.join(row))

def flipent_interpreter(grid):
    """Interprets the punch card grid as Flipent language commands."""
    commands = {
        'X': "SET BIT",
        '/': "HALF BIT"
    }
    
    for row_idx, row in enumerate(grid):
        for col_idx, cell in enumerate(row):
            if cell in commands:
                print(f"Executing {commands[cell]} at ({row_idx}, {col_idx})")

class FlipentApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Flipent GUI")
        
        self.create_menubar()
        
        self.version_label = tk.Label(root, text="Select MCO Punch Card Version (63B, 75B, 182B):")
        self.version_label.pack()
        
        self.version_var = tk.StringVar(value="63B")
        self.version_entry = tk.Entry(root, textvariable=self.version_var)
        self.version_entry.pack()
        
        self.pattern_label = tk.Label(root, text="Enter Flipent resume-pattern:")
        self.pattern_label.pack()
        
        self.pattern_var = tk.StringVar()
        self.pattern_entry = tk.Entry(root, textvariable=self.pattern_var)
        self.pattern_entry.pack()
        
        self.submit_button = tk.Button(root, text="Submit", command=self.process_input)
        self.submit_button.pack()
        
        self.output_text = tk.Text(root, height=20, width=50)
        self.output_text.pack()
    
    def create_menubar(self):
        menubar = tk.Menu(self.root)
        
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Exit", command=self.root.quit)
        menubar.add_cascade(label="File", menu=file_menu)
        
        tools_menu = tk.Menu(menubar, tearoff=0)
        tools_menu.add_command(label="Open IDLE", command=self.open_idle)
        menubar.add_cascade(label="Tools", menu=tools_menu)
        
        help_menu = tk.Menu(menubar, tearoff=0)
        help_menu.add_command(label="About", command=self.show_about)
        menubar.add_cascade(label="Help", menu=help_menu)
        
        self.root.config(menu=menubar)
    
    def show_about(self):
        messagebox.showinfo("About", "MCO Punch Card Software\nVersion 0.1a")
    
    def process_input(self):
        version = self.version_var.get().strip()
        pattern = self.pattern_var.get().strip()
        
        if version not in MCO_VERSIONS:
            messagebox.showerror("Error", "Invalid version. Choose from: 63B, 75B, 182B")
            return
        
        rows, cols = MCO_VERSIONS[version]
        try:
            grid = parse_resume_pattern(pattern, rows, cols)
            self.output_text.delete(1.0, tk.END)
            self.output_text.insert(tk.END, "Punch Card Grid:\n")
            for row in grid:
                self.output_text.insert(tk.END, ' '.join(row) + "\n")
            self.output_text.insert(tk.END, "\nInterpreted Commands:\n")
            for row_idx, row in enumerate(grid):
                for col_idx, cell in enumerate(row):
                    if cell == 'X':
                        self.output_text.insert(tk.END, f"Executing SET BIT at ({row_idx}, {col_idx})\n")
                    elif cell == '/':
                        self.output_text.insert(tk.END, f"Executing HALF BIT at ({row_idx}, {col_idx})\n")
        except Exception as e:
            messagebox.showerror("Error", str(e))
    
    def open_idle(self):
        idle_window = tk.Toplevel(self.root)
        idle_window.title("Flipent IDLE")
        
        idle_text = tk.Text(idle_window, height=20, width=50)
        idle_text.pack()
        
        def run_code():
            code = idle_text.get(1.0, tk.END).strip()
            if not code:
                return
            try:
                version, pattern = code.split('\n', 1)
                if version not in MCO_VERSIONS:
                    messagebox.showerror("Error", "Invalid version. Choose from: 63B, 75B, 182B")
                    return
                rows, cols = MCO_VERSIONS[version]
                grid = parse_resume_pattern(pattern, rows, cols)
                self.output_text.delete(1.0, tk.END)
                self.output_text.insert(tk.END, "Punch Card Grid:\n")
                for row in grid:
                    self.output_text.insert(tk.END, ' '.join(row) + "\n")
                self.output_text.insert(tk.END, "\nInterpreted Commands:\n")
                for row_idx, row in enumerate(grid):
                    for col_idx, cell in enumerate(row):
                        if cell == 'X':
                            self.output_text.insert(tk.END, f"Executing SET BIT at ({row_idx}, {col_idx})\n")
                        elif cell == '/':
                            self.output_text.insert(tk.END, f"Executing HALF BIT at ({row_idx}, {col_idx})\n")
            except Exception as e:
                messagebox.showerror("Error", str(e))
        
        run_button = tk.Button(idle_window, text="Run", command=run_code)
        run_button.pack()

if __name__ == "__main__":
    root = tk.Tk()
    app = FlipentApp(root)
    root.mainloop()
