import numpy as np
import typer

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

def flipent_repl(predefined_input=None):
    """Runs an interactive REPL for the Flipent language."""
    print("Flipent REPL - Select MCO Punch Card Version (63B, 75B, 182B)")
    input_source = iter(predefined_input) if predefined_input else None
    
    while True:
        try:
            version = next(input_source) if input_source else input("Select version: ").strip()
        except (StopIteration, EOFError):
            break
        
        if version not in MCO_VERSIONS:
            print("Invalid version. Choose from: 63B, 75B, 182B")
            continue
        
        rows, cols = MCO_VERSIONS[version]
        print(f"Selected MCO Punch Card {version} ({rows}x{cols})")
        
        while True:
            try:
                command = next(input_source) if input_source else input("flipent> ").strip()
            except (StopIteration, EOFError):
                return
            
            if command.lower() == 'exit':
                return
            
            try:
                grid = parse_resume_pattern(command, rows, cols)
                display_punch_card(grid)
                flipent_interpreter(grid)
            except Exception as e:
                print(f"Error: {e}")

def main(version: str = typer.Argument(..., help="MCO Punch Card Version (63B, 75B, 182B)"), 
         pattern: str = typer.Argument(..., help="Flipent resume-pattern")):
    if version not in MCO_VERSIONS:
        typer.echo("Invalid version. Choose from: 63B, 75B, 182B")
        raise typer.Exit(code=1)
    
    rows, cols = MCO_VERSIONS[version]
    grid = parse_resume_pattern(pattern, rows, cols)
    display_punch_card(grid)
    flipent_interpreter(grid)

if __name__ == "__main__":
    typer.run(main)
