# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related to general orbit functions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/orbit/general.jl
# ==========================================================================================

# Function: orbital_angular_velocity
# ------------------------------------------------------------------------------------------

############################################################################################
#                                       Test Results
############################################################################################
#
# The Amazonia-1 orbit is:
#
#   - Semi-major axis : 7130.982e3 m
#   - Excentricity    : 0.001111
#   - Inclination     : 98.405°
#
# and it performs 14 + 2 / 5 revolutions per day. Hence, its angular velocity is 0.06 °/s.
#
############################################################################################

@testset "Function orbital_angular_velocity" begin
    for T in (Float64, Float32)
        a   = T(7130.982e3)
        e   = T(0.001111)
        i   = T(98.405) |> deg2rad
        orb = KeplerianElements(0, a, e, i, 0, 0, 0)

        # J₀
        # ==================================================================================

        angvel = orbital_angular_velocity(a, e, i; perturbation = :J0)
        @test eltype(angvel) == T
        @test angvel ≈ √(GM_EARTH / a^3)

        angvel = orbital_angular_velocity(orb; perturbation = :J0)
        @test eltype(angvel) == T
        @test angvel ≈ √(GM_EARTH / a^3)

        # J₂
        # ==================================================================================

        angvel = orbital_angular_velocity(a, e, i)
        @test eltype(angvel) == T
        @test angvel ≈ deg2rad(0.06) atol = 4e-9

        angvel = orbital_angular_velocity(orb)
        @test eltype(angvel) == T
        @test angvel ≈ deg2rad(0.06) atol = 4e-9

        # J₄
        # ==================================================================================

        angvel = orbital_angular_velocity(a, e, i; perturbation = :J4)
        @test eltype(angvel) == T
        @test angvel ≈ deg2rad(0.06) atol = 4e-9

        angvel = orbital_angular_velocity(orb; perturbation = :J4)
        @test eltype(angvel) == T
        @test angvel ≈ deg2rad(0.06) atol = 4e-9
    end
end

@testset "Function orbital_angular_velocity [ERRORS]" begin
    @test_throws ArgumentError orbital_angular_velocity(7130.9e3, 0, 0; perturbation = :J3)
end

# Function: orbital_angular_velocity_to_semimajor_axis
# ------------------------------------------------------------------------------------------

############################################################################################
#                                       Test Results
############################################################################################
#
# The Amazonia-1 orbit is:
#
#   - Semi-major axis : 7130.982e3 m
#   - Excentricity    : 0.001111
#   - Inclination     : 98.405°
#
# and it performs 14 + 2 / 5 revolutions per day. Hence, its angular velocity is 0.06 °/s.
#
############################################################################################

@testset "Function orbital_angular_velocity_to_semimajor_axis" begin
    for T in (Float64, Float32)
        n   = T(0.06) |> deg2rad
        a   = T(7130.982e3)
        e   = T(0.001111)
        i   = T(98.405) |> deg2rad
        orb = KeplerianElements(0, a, e, i, 0, 0, 0)

        # J₀
        # ==================================================================================

        â = orbital_angular_velocity_to_semimajor_axis(n, e, i; perturbation = :J0)
        @test eltype(â) == T
        @test â ≈ (GM_EARTH / n^2)^(1 // 3)

        # J₂
        # ==================================================================================

        â = orbital_angular_velocity_to_semimajor_axis(n, e, i)
        @test eltype(â) == T
        @test â ≈ a atol = 2

        # J₄
        # ==================================================================================

        â = orbital_angular_velocity_to_semimajor_axis(n, e, i; perturbation = :J4)
        @test eltype(â) == T
        @test â ≈ a atol = 30
    end
end

@testset "Function orbital_angular_velocity_to_semimajor_axis [ERRORS]" begin
    @test_throws ArgumentError orbital_angular_velocity_to_semimajor_axis(0.001, 0, 0; perturbation = :J3)
end

# Function: orbital_period
# ------------------------------------------------------------------------------------------

############################################################################################
#                                       Test Results
############################################################################################
#
# The Amazonia-1 orbit is:
#
#   - Semi-major axis : 7130.982e3 m
#   - Excentricity    : 0.001111
#   - Inclination     : 98.405°
#
# and it performs 14 + 2 / 5 revolutions per day. Hence, its angular velocity is 0.06 °/s.
#
############################################################################################

@testset "Function orbital_period" begin
    for T in (Float64, Float32)
        a   = T(7130.982e3)
        e   = T(0.001111)
        i   = T(98.405) |> deg2rad
        orb = KeplerianElements(0, a, e, i, 0, 0, 0)

        # J₀
        # ==================================================================================

        period = orbital_period(a, e, i; perturbation = :J0)
        @test eltype(period) == T
        @test period ≈ 2π / √(GM_EARTH / a^3)

        period = orbital_period(orb; perturbation = :J0)
        @test eltype(period) == T
        @test period ≈ 2π / √(GM_EARTH / a^3)

        # J₂
        # ==================================================================================

        period = orbital_period(a, e, i)
        @test eltype(period) == T
        @test period ≈ 6000 atol = 1e-3

        period = orbital_period(orb)
        @test eltype(period) == T
        @test period ≈ 6000 atol = 1e-3

        # J₄
        # ==================================================================================

        period = orbital_period(a, e, i; perturbation = :J4)
        @test eltype(period) == T
        @test period ≈ 6000 atol = 2e-2

        period = orbital_period(orb; perturbation = :J4)
        @test eltype(period) == T
        @test period ≈ 6000 atol = 2e-2
    end
end

# Function: raan_time_derivative
# ------------------------------------------------------------------------------------------

############################################################################################
#                                       Test Results
############################################################################################
#
# The Amazonia-1 orbit is:
#
#   - Semi-major axis : 7130.982e3 m
#   - Excentricity    : 0.001111
#   - Inclination     : 98.405°
#
# and it is Sun-synchronous. Hence, the time-derivative of the RAAN must be close to
# 0.9856473598947981 ° / day.
#
############################################################################################

@testset "Function raan_time_derivative" begin
    for T in (Float64, Float32)
        a   = T(7130.982e3)
        e   = T(0.001111)
        i   = T(98.405) |> deg2rad
        orb = KeplerianElements(0, a, e, i, 0, 0, 0)

        # J₀
        # ==================================================================================

        ∂Ω = raan_time_derivative(a, e, i; perturbation = :J0)
        @test eltype(∂Ω) == T
        @test ∂Ω == T(0)

        ∂Ω = raan_time_derivative(orb; perturbation = :J0)
        @test eltype(∂Ω) == T
        @test ∂Ω == T(0)

        # J₂
        # ==================================================================================

        ∂Ω = raan_time_derivative(a, e, i)
        @test eltype(∂Ω) == T
        @test rad2deg(∂Ω) * 86400  ≈ 0.9856473598947981 atol = 1e-3

        ∂Ω = raan_time_derivative(orb)
        @test eltype(∂Ω) == T
        @test rad2deg(∂Ω) * 86400 ≈ 0.9856473598947981 atol = 1e-3

        # J₄
        # ==================================================================================

        ∂Ω = raan_time_derivative(a, e, i; perturbation = :J4)
        @test eltype(∂Ω) == T
        @test rad2deg(∂Ω) * 86400  ≈ 0.9856473598947981 atol = 2e-3

        ∂Ω = raan_time_derivative(orb; perturbation = :J4)
        @test eltype(∂Ω) == T
        @test rad2deg(∂Ω) * 86400  ≈ 0.9856473598947981 atol = 2e-3
    end
end

@testset "Function raan_time_derivative [ERRORS]" begin
    @test_throws ArgumentError raan_time_derivative(7000e3, 0, 0; perturbation = :J3)
end
