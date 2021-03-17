# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Structures related to the orbit propagators.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export OrbitPropagator

"""
    OrbitPropagator{T}

Abstract type of the orbit propagator. Every propagator structure must be a
subtype of this type and must implement the following API functions:

    propagate!(orbp, t::Number)
    propagate!(orbp, t::AbstractVector)
    propagate_to_epoch!(orbp, JD::Number)
    propagate_to_epoch!(orbp, JD::AbstractVector)
    step!(orbp, Δt::Number)

"""
abstract type OrbitPropagator{T} end

#                          Two Body Orbit Propagator
# ==============================================================================

export TwoBody_Structure, OrbitPropagatorTwoBody

"""
    TwoBody_Structure{T}

Low level Two Body orbit propagator structure.

"""
mutable struct TwoBody_Structure{T}
    # Initial parameters.
    epoch::T
    a_0::T
    e_0::T
    i_0::T
    Ω_0::T
    ω_0::T
    M_0::T
    f_0::T
    # Propagation time from epoch.
    Δt::T
    # Mean motion.
    n_0::T
    # Current parameters.
    M_k::T
    f_k::T
    # Standard gravitational parameter of the central body [m^3/s^2].
    μ::T
end

"""
    OrbitPropagatorTwoBody{T} <: OrbitPropagator{T}

Structure that holds the information related to the Two Body orbit propagator.

# Fields

* `orb`: Mean orbital elements (see `Orbit`).
* `tbd`: Structure that stores the Two Body orbit propagator data (see
        `TwoBody_Structure`).

"""
mutable struct OrbitPropagatorTwoBody{T} <: OrbitPropagator{T}
    orb::Orbit{T,T}

    # Two Body orbit propagator related fields.
    tbd::TwoBody_Structure{T}
end


#                             J2 Orbit Propagator
# ==============================================================================

export J2_GravCte, J2_Structure, OrbitPropagatorJ2

"""
    J2_GravCte{T}

Gravitational constants for J2 orbit propagator.

# Fields

* `R0`: Earth equatorial radius [m].
* `μm`: √GM [er/s]^(3/2).
* `J2`: The second gravitational zonal harmonic of the Earth.

"""
@with_kw struct J2_GravCte{T}
    R0::T
    μm::T
    J2::T
end

"""
    J2_Structure{T}

Low level J2 orbit propagator structure.

"""
@with_kw mutable struct J2_Structure{T}
    # Initial mean orbital elements.
    epoch::T
    al_0::T    # Normalized semi-major axis [er].
    n_0::T
    e_0::T
    i_0::T
    Ω_0::T
    ω_0::T
    f_0::T
    M_0::T
    # Drag parameters.
    dn_o2::T   # First time derivative of mean motion [rad/s²].
    ddn_o6::T  # Second time derivative of mean motion [rad/s³].
    # Propagation time from epoch.
    Δt::T
    # Current mean orbital elements.
    al_k::T    # Normalized semi-major axis [er].
    e_k::T
    i_k::T
    Ω_k::T
    ω_k::T
    f_k::T
    M_k::T
    # First-order time-derivative of the orbital elements.
    δa::T
    δe::T
    δΩ::T
    δω::T
    δM_0::T
    # J2 orbit propagator gravitational constants.
    j2_gc::J2_GravCte{T}
end

"""
    OrbitPropagatorJ2{T} <: OrbitPropagator{T}

Structure that holds the information related to the J2 orbit propagator.

# Fields

* `orb`: Mean orbital elements (see `Orbit`).
* `j2d`: Structure that stores the J2 orbit propagator data (see
         `J2_Structure`).

"""
mutable struct OrbitPropagatorJ2{T} <: OrbitPropagator{T}
    orb::Orbit{T,T}

    # J2 orbit propagator related fields.
    j2d::J2_Structure{T}
end

#                        J2 osculating orbit propagator
# ==============================================================================

export J2osc_Strutcture

"""
    J2osc_Structure{T}

Low level J2 osculating orbit propagator structure.

"""
@with_kw mutable struct J2osc_Structure{T}
    # J2 orbit propagator to propagate the mean elements.
    j2d::J2_Structure{T}
    # Propagation time from epoch.
    Δt::T
    # Current osculating Keplerian elements.
    a_k::T
    e_k::T
    i_k::T
    Ω_k::T
    ω_k::T
    f_k::T
    M_k::T
end

#                             J4 orbit propagator
# ==============================================================================

export J4_GravCte, J4_Structure, OrbitPropagatorJ4

"""
    J4_GravCte{T}

Gravitational constants for J4 orbit propagator.

# Fields

* `R0`: Earth equatorial radius [m].
* `μm`: √GM [er/s]^(3/2).
* `J2`: The second gravitational zonal harmonic of the Earth.
* `J4`: The fourth gravitational zonal harmonic of the Earth.

"""
@with_kw struct J4_GravCte{T}
    R0::T
    μm::T
    J2::T
    J4::T
end

"""
    J4_Structure{T}

Low level J4 orbit propagator structure.

"""
@with_kw mutable struct J4_Structure{T}
    # Initial mean orbital elements.
    epoch::T
    al_0::T
    n_0::T
    e_0::T
    i_0::T
    Ω_0::T
    ω_0::T
    f_0::T
    M_0::T
    # Propagation time from epoch.
    Δt::T
    # Drag parameters.
    dn_o2::T   # First time derivative of mean motion [rad/s²].
    ddn_o6::T  # Second time derivative of mean motion [rad/s³].
    # Current mean orbital elements.
    al_k::T
    e_k::T
    i_k::T
    Ω_k::T
    ω_k::T
    f_k::T
    M_k::T
    # First-order time-derivative of the orbital elements.
    δa::T
    δe::T
    δΩ::T
    δω::T
    δM_0::T
    # J4 orbit propagator gravitational constants.
    j4_gc::J4_GravCte{T}
end

"""
    OrbitPropagatorJ4{T} <: OrbitPropagator{T}

Structure that holds the information related to the J4 orbit propagator.

# Fields

* `orb`: Mean orbital elements (see `Orbit`).
* `j4d`: Structure that stores the J4 orbit propagator data (see
         `J4_Structure`).

"""
mutable struct OrbitPropagatorJ4{T} <: OrbitPropagator{T}
    orb::Orbit{T,T}

    # J4 orbit propagator related fields.
    j4d::J4_Structure{T}
end

#                                     SGP4
# ==============================================================================

export OrbitPropagatorSGP4

"""
    OrbitPropagatorSGP4{T} <: OrbitPropagator{T}

Structure that holds the information related to the SGP4 propagator.

# Fields

* `orb`: Mean orbital elements (see `Orbit`).
* `sgp4_gc`: Gravitational contents of the SGP4 algorithm (see `SGP4_GravCte`).
* `sgp4d`: Structure that stores the SGP4 data (see `SGP4_Structure`).
"""
mutable struct OrbitPropagatorSGP4{T} <: OrbitPropagator{T}
    orb::Orbit{T,T}

    # SGP4 related fields.
    sgp4_gc::SGP4_GravCte{T}
    sgp4d::SGP4_Structure{T}
end
