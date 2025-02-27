import typer

class FlipentInterpreter:
    def __init__(self):
        self.memory = {}  # Store variables, data, etc.
        self.functions = {}  # Store defined functions
        self.stack = []  # Call stack for function execution

    def flip(self, bit):
        """Flip a bit (0 to 1, 1 to 0)."""
        return 1 - bit

    def half(self, value):
        """Simulate a 'half bit' (e.g., returning a fractional bit)."""
        if value == '¹':
            return 0.5
        elif value == '²':
            return 0.25
        elif value == '³':
            return 0.125
        return 0

    def bitwise_operations(self, bit1, bit2, operation):
        """Perform bitwise operations like AND, OR, XOR."""
        if operation == 'AND':
            return bit1 & bit2
        elif operation == 'OR':
            return bit1 | bit2
        elif operation == 'XOR':
            return bit1 ^ bit2
        return None

    def mini(self, code_block):
        """Minify a function-like code block by simplifying the operations."""
        # Example: Simplify redundant flip operations or similar patterns
        return code_block.strip()  # Placeholder logic for minification

    def define_function(self, func_name, func_code):
        """Define a function in the interpreter."""
        self.functions[func_name] = func_code

    def call_function(self, func_name):
        """Call a defined function."""
        if func_name in self.functions:
            self.run(self.functions[func_name])
        else:
            print(f"Function {func_name} not defined.")

    def parse_line(self, line):
        """Parse each line and interpret commands."""
        parts = line.strip().split()

        if len(parts) == 0:
            return

        command = parts[0]

        if command == "flip":
            bit = int(parts[1])
            return self.flip(bit)

        elif command == "half":
            value = parts[1]
            return self.half(value)

        elif command == "bitwise":
            bit1 = int(parts[1])
            bit2 = int(parts[2])
            operation = parts[3]
            return self.bitwise_operations(bit1, bit2, operation)

        elif command == "%mini":
            code_block = " ".join(parts[1:])
            return self.mini(code_block)

        elif command == "def":
            func_name = parts[1]
            func_code = " ".join(parts[2:])
            self.define_function(func_name, func_code)

        elif command == "call":
            func_name = parts[1]
            self.call_function(func_name)

        # Add more custom command handling here

    def run(self, program):
        """Run the Flipent program."""
        program_lines = program.splitlines()
        for line in program_lines:
            result = self.parse_line(line)
            if result is not None:
                print(f"Result: {result}")

    def repl(self):
        """Run a REPL (Read-Eval-Print Loop) for interactive use."""
        print("Welcome to Flipent REPL. Type 'exit' to quit.")
        while True:
            try:
                line = input(">>> ")
                if line.lower() == "exit":
                    print("Exiting REPL...")
                    break
                self.run(line)
            except Exception as e:
                print(f"Error: {e}")

app = typer.Typer()

@app.command()
def run(file: str):
    """Run a Flipent program from a file."""
    try:
        with open(file, "r") as f:
            program = f.read()
        interpreter = FlipentInterpreter()
        interpreter.run(program)
    except FileNotFoundError:
        print(f"Error: The file '{file}' was not found.")

@app.command()
def repl():
    """Start the Flipent REPL (Interactive mode)."""
    interpreter = FlipentInterpreter()
    interpreter.repl()

if __name__ == "__main__":
    app()
