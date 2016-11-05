# Given a number of operands and a result guess the operators
# which fit between each operand to solve the equation.

import bisect


class MathOperator(object):
    def __repr__(self):
        return self.Symbol


class Add(MathOperator):
    Precedence = 1
    Symbol = '+'

    def calculate(self, a, b):
        return a + b


class Subtract(MathOperator):
    Precedence = 1
    Symbol = '-'

    def calculate(self, a, b):
        return a - b


class Multiply(MathOperator):
    Precedence = 2
    Symbol = '*'

    def calculate(self, a, b):
        return a * b


class Divide(MathOperator):
    Precedence = 2
    Symbol = '/'

    def calculate(self, a, b):
        return a // b


class EquationBuilder(object):
    """ Build a simple math equation using chaining. Each operation returns
    a new instance of an EquationBuilder with the new operator and operand
    appended.

    The expression is stored as a tuple of infix operands and operators.

    (1, Add(), 5, Subtract() 10)

    Brackets and unary operators are not supported in this version.

    """
    OpLookup = {'+': Add(),
                '-': Subtract(),
                '*': Multiply(),
                '/': Divide()}


    def __init__(self, operand):
        if operand:
            self._equation = (operand,)

        self._value = None

    def __repr__(self):
        return '%s = %s' % (' '.join((str(elem) for elem in self._equation)),
                            self.calculate())

    def append(self, operator, operand):
        """Add a new operator and operand to the expression.

        Keyword arguments:
        operator (str): '+', '-', '*', '/'
        operand (int): number associated with operator.

        """
        e = EquationBuilder(None)

        if isinstance(operator, str):
            try:
                operator = self.OpLookup[operator]
            except KeyError:
                raise ValueError('Invalid operator: %s' % (operator))

        e._equation = self._equation + (operator, operand)

        return e

    def add(self, operand):
        return self.append('+', operand)
        
    def subtract(self, operand):
        return self.append('-', operand)

    def multiply(self, operand):
        return self.append('*', operand)

    def divide(self, operand):
        return self.append('/', operand)

    def calculate(self):
        if not self._value:
            self._value = self._calculate()

        return self._value

    def _calculate(self):
        """Simple postfix evaluator.

        """
        operands = []

        for token in self._get_postfix():
            if isinstance(token, int):
                operands.append(token)
            elif isinstance(token, MathOperator):
                operator = token
                b = operands.pop()
                a = operands.pop()
                operands.append(operator.calculate(a, b))

        return operands.pop()

    def _get_postfix(self):
        """Convert expression to postfix.

        """
        operators = []
        output = []
        for token in self._equation:
            if isinstance(token, int):
                output.append(token)
            if isinstance(token, MathOperator):
                while operators and operators[-1].Precedence >= token.Precedence:
                    output.append(operators.pop())
                operators.append(token)

        while operators:
            output.append(operators.pop())

        return output


class Guess(object):
    """Class to store a guess, consisting of an equation and the abs
    difference between the expected answer and the guessed equation.

    This is used to allow sorting of guesses based on the difference.

    """
    def __init__(self, equation, answer):
        self._answer = answer
        self._equation = equation
        self._difference = abs(self._answer - self._equation.calculate())

    def __repr__(self):
        return '%s (%d)' % (self._equation, self._difference)

    @property
    def difference(self):
        return self._difference

    @property
    def solved(self):
        return self._difference == 0

    @property
    def equation(self):
        return self._equation

    def __lt__(self, other):
        return self.difference < other.difference

    def __le__(self, other):
        return self.difference <= other.difference

    def __gt__(self, other):
        return self.difference > other.difference

    def __ge__(self, other):
        return self.difference >= other.difference
    

class MaxTriesExceededError(BaseException):
    pass


class EquationGuesser(object):
    """Get a list of best guest equations using a kind of heuristic breadth first
    search.

    """
    def __init__(self, values, answer):
        self._values = values
        self._answer = answer

    def guess(self, max_tries):
        guesses = [Guess(EquationBuilder(self._values[0]), self._answer)]

        try:
            for index, num in enumerate(self._values[1:], start=1):
                last_guesses = guesses

                # pruning the less promising branches speeds things up quite
                # significantly and becausee we're using heuristics we still
                # have a reasonable chance at solving the equation.
                if len(last_guesses) > 100:
                    del last_guesses[int(len(last_guesses) * 0.5):]

                guesses = []

                for guess in last_guesses:
                    for operator in ('+', '-', '*', '/'):
                        try:
                            new_guess = Guess(guess.equation.append(operator, num),
                                              self._answer)
                            bisect.insort(guesses, new_guess)

                            # if we've used all the operands
                            if index == len(self._values) - 1:
                                max_tries -= 1

                                if max_tries <= 0 or new_guess.solved:
                                    raise StopIteration

                        except ZeroDivisionError:
                            pass

        except StopIteration:
            pass

        return guesses


if __name__ == '__main__':
    import time

    solver = EquationGuesser([1,2,3,4,5,6,7,8,9,10], 5155)
    start_tm = time.time()
    guesses = solver.guess(10000)
    end_tm = time.time()

    for guess in guesses:
        print(guess)

    print('Best guess: %s' % (guesses[0]))
    print('Completed in %.4f seconds' % (end_tm - start_tm))

