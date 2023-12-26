module DirectDedispersion

const 𝓓 = 4.1488064239e3
Δt(f₁, f₂, dm) = 𝓓 * dm * (f₁^-2 - f₂^-2)

function Δξ!(ξ; f₀, nf, Δf, δt, dm)
    for i ∈ eachindex(ξ)
        i′ = i - 1
        f = f₀ - (i′ * Δf / nf)
        ξ[i] = Δt(f, f₀, dm) ÷ δt
    end
end

function Δξ(; f₀, nf, Δf, δt, dm)
    ξ = zeros(Int64, nf)
    Δξ!(ξ; f₀, nf, Δf, δt, dm)
    ξ
end

function dd!(X, I; f₀, Δf, δt, dm)
    nf, nt = size(I)
    ξ = Δξ(; f₀, nf, Δf, δt, dm)
    @inbounds for i ∈ axes(I, 1)
        @inbounds for j ∈ eachindex(X)
            j′ = j + ξ[i]
            if j′ <= nt
                X[j] += I[CartesianIndex(i, j′)]
            end
        end
    end
end

function dd(I; f₀, Δf, δt, dm)
    X = zeros(Float64, size(I, 2))
    dd!(X, I; f₀, Δf, δt, dm)
    X
end

end
