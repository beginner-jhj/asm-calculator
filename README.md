# 🧮 NASM Integer Calculator

This is a simple command-line calculator written entirely in **x86 NASM Assembly** for Linux. It performs **basic integer arithmetic**: addition, subtraction, multiplication, and division — with full support for **negative numbers** and **user input** from the terminal.

---

## ✨ Features

- 🧠 Fully written in low-level x86 Assembly
- 🖥 Accepts user input from standard input (stdin)
- ➕➖✖️➗ Supports `+`, `-`, `*`, `/` operations
- ❗ Handles negative numbers
- 🔢 Converts ASCII to integer and back
- 📤 Prints result to terminal with `sys_write`
- 🚫 Handles divide-by-zero with clean exit

---

## 📦 Requirements

- Linux environment (or WSL, or a VM)
- `nasm` assembler
- `gcc` linker

---

## ⚙️ How It Works

### 1. **User Input**

The program sequentially prompts the user for:
- First number
- Second number
- Operator (`+`, `-`, `*`, `/`)

All inputs are read using the `sys_read` system call.

---

### 2. **ASCII to Integer Conversion**

The `ascii_to_int` function:
- Skips a leading `'-'` and sets a flag if negative
- Parses the digits one by one
- Builds the final value in `EAX`
- Applies `NEG` if the negative flag is set

---

### 3. **Operator Dispatch**

The operator (`+`, `-`, `*`, `/`) is read and compared using `cmp` + `je`.  
Then the corresponding operation is performed using:
- `add`
- `sub`
- `imul`
- `div`

Division checks for zero to avoid a crash.

---

### 4. **Integer to ASCII Conversion**

The `int_to_ascii` function:
- Converts EAX to characters using repeated division by 10
- Stores characters in reverse order
- Adds a `'-'` prefix if the original number was negative
- Calculates the string's length for display

---

### 5. **Result Display**

The result is written to standard output (`stdout`) using `sys_write`, followed by a newline.

---

## 🚀 Build & Run

### 🔧 Assemble and Link
```bash
nasm -f elf32 calculator.asm -o calculator.o
gcc -m32 -nostartfiles calculator.o -o calculator
./calculator

```

## 📝 Sample Output

```bash
Enter first number: -10
Enter second number: 5
Enter operation (+, -, *, /): /
Result: -2
```