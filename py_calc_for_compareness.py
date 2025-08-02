num1 = int(input("Enter first number: "))
num2 = int(input("Enter second number: "))
op = input("Enter operation (+, -, *, /): ")
result = None

if op == '+':
    result = num1 + num2

elif op == '-':
    result = num1 - num2

elif op == '*':
    result = num1 * num2

elif op == '/':
    if num2 != 0:
        result = num1 / num2
    else:
        print("Error: Division by zero is not allowed.")

if result is not None:
    print(f"The result of {num1} {op} {num2} is: {result}")
