import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess
import sys

root = tk.Tk()
root.title("OliviaASM IDE")
root.geometry("800x600")

code_text = tk.Text(root, font=("Courier New", 12), wrap=tk.NONE)
code_text.pack(fill=tk.BOTH, expand=True)

button_frame = tk.Frame(root)
button_frame.pack(fill=tk.X)

def show_scrollable_output(title, content, error=False):
    output_window = tk.Toplevel(root)
    output_window.title(title)
    output_window.geometry("600x400")

    text_area = tk.Text(output_window, wrap=tk.WORD, bg="#fff0f0" if error else "#f0fff0")
    text_area.insert(tk.END, content)
    text_area.config(state=tk.DISABLED)
    text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

    scrollbar = tk.Scrollbar(output_window, command=text_area.yview)
    scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
    text_area.config(yscrollcommand=scrollbar.set)

def assemble_and_run():
    with open("input.asm", "w") as f:
        f.write(code_text.get("1.0", tk.END))

    try:
        result = subprocess.run(
            [sys.executable, "run.py"],
            capture_output=True,
            text=True
        )

        if result.returncode == 0:
            show_scrollable_output("Simulation Completed", result.stdout)
        else:
            show_scrollable_output("Simulation Failed", result.stderr, error=True)

    except Exception as e:
        messagebox.showerror("Error", f"Failed to run simulation:\n{str(e)}")

tk.Button(button_frame, text="Assemble + Run", command=assemble_and_run).pack(side=tk.LEFT, padx=5)

code_text.insert("1.0", """# OliviaASM Example
SOAMERICAN X1, X2, X3
VAMPIRE X4, X6, X5
GETHIMBACK X7, X8, #16
STRANGER X9, X10, #32
TEENAGEDREAM start
LOGICAL X11, 8
start:
REDLIGHT
""")

root.mainloop()
