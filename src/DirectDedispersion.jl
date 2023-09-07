module DirectDedispersion

const 𝓓 = 4.1488064239e3
Δt(f₁, f₂, DM) = 𝓓 * DM * (f₁^-2 - f₂^-2)

function Δξ!(
    ξ;
    f₀,
    nf,
    nt,
    Δf,
    δt,
    DM
)
    for i ∈ eachindex(ξ)
        i′ = i - 1
        f = f₀ - (i′ * Δf / nf)
        ξᵢ = Δt(f, f₀, DM) ÷ δt
        ξ[i] = ξᵢ < nt ? ξᵢ : 0
    end
end

function Δξ(; f₀, nf, nt, Δf, δt, DM)
    ξ = zeros(Int64, nf)
    Δξ!(ξ; f₀, nf, nt, Δf, δt, DM)
    ξ
end

function dd(
    I;
    f₀,
    Δf,
    δt,
    DM
)
    nf, nt = size(I)
    ξ = Δξ(; f₀, nf, nt, Δf, δt, DM)
    X = zeros(Float64, nt - maximum(ξ))
    @inbounds Threads.@threads for i ∈ axes(I, 1)
        @inbounds for j ∈ eachindex(X)
            X[j] += I[CartesianIndex(i, j + ξ[i])]
        end
    end
    X
end

end
