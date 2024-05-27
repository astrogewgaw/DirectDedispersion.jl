module DirectDedispersion

const 𝓓 = 4.1488064239e3

function dd!(X::AbstractVector, I::AbstractMatrix, fₕ, Δf, δt, dm)
    nf, nt = size(I)
    @inbounds for i ∈ axes(I, 1)
        f = fₕ - ((i - 1) * Δf / nf)
        ξ = round(Int, 𝓓 * dm * (f^-2 - fₕ^-2) / δt)
        @inbounds for j ∈ eachindex(X)
            jj = j + ξ
            if jj < nt
                X[j] += I[CartesianIndex(i, jj)]
            end
        end
    end
end

function dd(I::AbstractMatrix, fₕ, Δf, δt, dm)
    X = zeros(Float64, size(I, 2))
    dd!(X, I, fₕ, Δf, δt, dm)
    X
end

function dd!(DMT::AbstractMatrix, I::AbstractMatrix, fₕ, Δf, δt, dmₗ, dmₕ)
    ndms = size(DMT, 1)
    for i ∈ axes(DMT, 1)
        δdm = (dmₕ - dmₗ) / (ndms - 1)
        dm = dmₗ + ((i - 1) * δdm)
        @views dd!(DMT[i, :], I, fₕ, Δf, δt, dm)
    end
end

function dd(I::AbstractMatrix, fₕ, Δf, δt, dmₗ, dmₕ, ndms)
    DMT = zeros(Float64, (ndms, size(I, 2)))
    dd!(DMT, I, fₕ, Δf, δt, dmₗ, dmₕ)
    DMT
end

end
