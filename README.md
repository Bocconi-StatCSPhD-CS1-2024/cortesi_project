### The Problem I Am Trying to Solve

My project addresses the numerical solution of Fredholm integral equations of the second kind, which have the general form:
f(x) = g(x) + λ ∫[a,b] K(x, t) f(t) dt
where
- K(x,t) is the kernel function, representing the relationship between x and t
- g(x) is a known function
- λ is a scalar parameter
- f(x) is the unknown function to be solved for.

How Does the Fredholm Integral Equation Work?
The unknown function f(x) depends on two components, a known part g(x), representing the direct influence on f(x), and a cumulative effect, which captures how all points t in the interval [a, b] influence x. The cumulative effect is given by a kernel function K(x, t), describing how much each point t influences x, and by an integral, summing up the contributions of all points t within the interval. The effect is scaled on the basis of a factor λ, which can either amplify or reduce it.

Solving these equations numerically is critical when analytical solutions are unavailable or impractical.
An example of potential application of Fredholm integral equations is signal processing, to model the relationship between input and output signals.


### Brief Description of How the Code Solves the Problem

The code numerically solves the Fredholm integral equation of the second kind by implementing a series of computational techniques:
1. The continuous integration interval [a,b] is discretized into n evenly spaced points using the range function.
2. The kernel function K(x,t), defined as a user input, is evaluated on a grid formed by the discretized points, resulting in the kernel matrix.
3. Weights for numerical integration are computed using the trapezoidal rule. These weights are applied to the kernel matrix to approximate the integral.
4. The integral equation is transformed into a linear system A⋅F=G, where A incorporates the kernel matrix, weights, and scalar parameter λ. The unknown F is solved using the inverse divide operation (A \ G).
5. One of the challenges was the validity of inputs. To ensure it, the code includes checks to validate user inputs, default values for convenience, and error messages for invalid inputs.

(Other) Challenges

- Allowing the user to input custom functions (K(x,t) and g(x)) was initially challenging. This was resolved with solutions and ideas found online.
- The program is designed for dense kernel matrices. While this works well for smaller problems, it may become inefficient for larger-scale problems or sparse kernels due to increased memory usage.

Potential Improvements
- Implement additional methods to compute weights for numerical integration, such as Gaussian quadrature or Simpson's rule, to provide more flexibility.
- Add a plot of the solution F(x) or the kernel matrix.
- Introduce parallel programming techniques to optimize the computation. This could significantly reduce runtime and improve performance.


### Examples of How to Run the Code

To run the program, execute the main() function. The program will prompt you to enter the required inputs step by step. Below are two examples of inputs and expected outputs.

## EXAMPLE 1- INPUT

integration interval: 0 2
lambda: 0.2
number of discretization points: 4
kernel: x + t
g: x^3 + 1

## EXAMPLE 1 - OUTPUT

Function g(x) defined successfully.

Discretized points of the interval (up to 10 elements shown):
[0.0, 0.6666666666666666, 1.3333333333333333, 2.0]

Kernel matrix (up to 5 x 5 elements shown):
0.000  0.667  1.333  2.000
0.667  1.333  2.000  2.667
1.333  2.000  2.667  3.333
2.000  2.667  3.333  4.000

Weights vector (up to 10 elements shown):
[0.3333333333333333, 0.6666666666666666, 0.6666666666666666, 0.3333333333333333]

Weighted kernel matrix (up to 5 x 5 elements shown):
0.000  0.444  0.889  0.667
0.222  0.889  1.333  0.889
0.444  1.333  1.778  1.111
0.667  1.778  2.222  1.333

Scaled kernel matrix by λ (up to 5 x 5 elements shown):
0.000  0.089  0.178  0.133
0.044  0.178  0.267  0.178
0.089  0.267  0.356  0.222
0.133  0.356  0.444  0.267

G vector (up to 10 elements shown):
[1.0, 1.2962962962962963, 3.3703703703703702, 9.0]

Matrix A (up to 5 x 5 elements shown):
1.000  -0.089  -0.178  -0.133
-0.044  0.822  -0.267  -0.178
-0.089  -0.267  0.644  -0.222
-0.133  -0.356  -0.444  0.733

Approximation of the vector F based on the linear system (first 10 elements shown):
[14.902319902319901, 22.80952380952381, 32.494505494505496, 45.735042735042725]

That's great!

## EXAMPLE 2 - INPUT

integration interval: 0 1
lambda: 0.5
number of discretization points: 4
kernel: x * t
g: x^2

## EXAMPLE 2 - OUTPUT

Discretized points of the interval (up to 10 elements shown):
[0.0, 0.3333333333333333, 0.6666666666666666, 1.0]

Kernel matrix (up to 5 x 5 elements shown):
0.000  0.000  0.000  0.000
0.000  0.111  0.222  0.333
0.000  0.222  0.444  0.667
0.000  0.333  0.667  1.000

Weights vector (up to 10 elements shown):
[0.16666666666666666, 0.3333333333333333, 0.3333333333333333, 0.16666666666666666]

Weighted kernel matrix (up to 5 x 5 elements shown):
0.000  0.000  0.000  0.000
0.000  0.037  0.074  0.056
0.000  0.074  0.148  0.111
0.000  0.111  0.222  0.167

Scaled kernel matrix by λ (up to 5 x 5 elements shown):
0.000  0.000  0.000  0.000
0.000  0.019  0.037  0.028
0.000  0.037  0.074  0.056
0.000  0.056  0.111  0.083

G vector (up to 10 elements shown):
[0.0, 0.1111111111111111, 0.4444444444444444, 1.0]

Matrix A (up to 5 x 5 elements shown):
1.000  0.000  0.000  0.000
0.000  0.981  -0.037  -0.028
0.000  -0.037  0.926  -0.056
0.000  -0.056  -0.111  0.917

Approximation of the vector F based on the linear system (first 10 elements shown):
[0.0, 0.16729088639200998, 0.5568039950062422, 1.1685393258426966]

That's great!

###
