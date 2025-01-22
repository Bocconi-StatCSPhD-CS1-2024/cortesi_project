# =====================================
# Dependencies
# =====================================
using Printf
using LinearAlgebra

# =====================================
# Input Functions
# =====================================
function get_kernel()
    println("Enter the kernel K(x, t), for example: x * t")
    println("Press Enter to use the default value: K(x, t) = x * t")
    while true
        try
            input = readline()
            if isempty(input)
                println("Default value used: K(x, t) = x * t")
                return (x, t) -> x * t
            end

            K = eval(Meta.parse("(x, t) -> " * input))
            println("Kernel K(x, t) defined successfully.")
            return K
        catch
            println("Error: The kernel entered is invalid. Make sure to use a valid expression, e.g., x + t.")
        end
    end
end

function get_function()
    println("Enter the function g(x), for example: x^2")
    println("Press Enter to use the default value: g(x) = x^2")
    while true
        try
            g_function = readline()
            if isempty(g_function)
                println("Default value used: g(x) = x^2")
                return x -> x^2
            end

            g = eval(Meta.parse("x -> " * g_function))
            println("Function g(x) defined successfully.")
            return g
        catch
            println("Error: The function entered is invalid. Make sure to use a valid expression, e.g., x^3.")
        end
    end
end

function get_interval()
    println("Enter the integration interval as two numbers separated by a space, for example: 0 1")
    while true
        try
            input = readline()
            interval = split(input)
            a, b = parse(Float64, interval[1]), parse(Float64, interval[2])
            if a >= b
                println("Error: The lower limit (a) must be smaller than the upper limit (b). Try again.")
                continue
            end
            return a, b
        catch
            println("Error: Enter two valid numbers separated by a space. Try again.")
        end
    end
end

function get_lambda()
    println("Enter the value of lambda, for example: 0.5")
    while true
        try
            λ = parse(Float64, readline())
            if λ <= 0
                println("Error: Lambda must be greater than 0. Try again.")
                continue
            end
            return λ
        catch
            println("Error: Enter a valid number for lambda, e.g., 3. Try again.")
        end
    end
end

function get_points()
    println("Enter the number (integer) of discretization points, for example: 100")
    while true
        try
            n = parse(Int, readline())
            if n < 2
                println("Error: The number of points must be at least 2. Try again.")
                continue
            end
            return n
        catch
            println("Error: Enter a valid integer for the number of points. Try again.")
        end
    end
end

# =====================================
# Vector and Matrix Operations
# =====================================
function discretize_interval(a::Float64, b::Float64, n::Int)
    return collect(range(a, stop=b, length=n))
end

function create_kernel_grid(points::Vector{Float64}, K::Function)
    return [Base.invokelatest(K, x, t) for x in points, t in points]
end

function apply_weights(kernel_matrix::Matrix{Float64}, weights::Vector{Float64})
    return kernel_matrix .* weights'
end

function compute_weights(a::Float64, b::Float64, n::Int)
    Δx = (b - a) / (n - 1)
    weights = fill(Δx, n)
    weights[1] /= 2
    weights[end] /= 2
    return weights
end

function scale_kernel_matrix(kernel_matrix::Matrix{Float64}, λ::Float64)
    return λ * kernel_matrix
end

function compute_g_vector(points::Vector{Float64}, g::Function)
    return [Base.invokelatest(g, x) for x in points]
end

# =====================================
# Display Functions
# =====================================
function display_points(vector::Vector{Float64})
    l = length(vector)
    if l <= 10
        println(vector)
    else
        println(vector[1:10])
    end
end

function display_matrix(matrix::Matrix{Float64})
    n_rows, n_cols = size(matrix)
    submatrix = matrix[1:min(n_rows, 5), 1:min(n_cols, 5)]
    for row in eachrow(submatrix)
        formatted_row = [@sprintf("%.3f", x) for x in row]
        println(join(formatted_row, "  "))
    end
end

# =====================================
# Main
# =====================================
function main()
    # Get user inputs
    a, b = get_interval()
    λ = get_lambda()
    n = get_points()
    K = get_kernel()
    g = get_function()

    # Discretize interval
    points = discretize_interval(a, b, n)
    println("\nDiscretized points of the interval (up to 10 elements shown):")
    display_points(points)

    # Create the kernel grid
    kernel_matrix = create_kernel_grid(points, K)
    println("\nKernel matrix (up to 5 x 5 elements shown):")
    for row in eachrow(kernel_matrix)
        formatted_row = [@sprintf("%.3f", x) for x in row]
        println(join(formatted_row, "  "))
    end 

    # Multiply elements by specific weights (trapezoidal method)
    weights = compute_weights(a, b, n)
    println("\nWeights vector (up to 10 elements shown):")
    display_points(weights)
    
    weighted_kernel = apply_weights(kernel_matrix, weights)
    println("\nWeighted kernel matrix (up to 5 x 5 elements shown):")
    display_matrix(weighted_kernel)

    # Scale the kernel matrix by lambda
    scaled_kernel = scale_kernel_matrix(weighted_kernel, λ)
    println("\nScaled kernel matrix by λ (up to 5 x 5 elements shown):")
    display_matrix(scaled_kernel)

    # Create the linear system
    G = compute_g_vector(points, g)
    println("\nG vector (up to 10 elements shown):")
    display_points(G)

    identity_matrix = Matrix{Float64}(I, n, n)
    A = identity_matrix - scaled_kernel
    println("\nMatrix A (up to 5 x 5 elements shown):")
    display_matrix(A)
    if det(A) == 0
        error("Error: Matrix A is not invertible.")
    end

    # Solve the linear system
    F = A \ G
    println("\nApproximation of the vector F based on the linear system (first 10 elements shown):")
    display_points(F)
    println("\nThat's great!")
end
