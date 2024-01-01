module DirectDedispersion

const 𝓓 = 4.1488064239e3

function dd!(X, I; f₀, Δf, δt, dm)
    nf, nt = size(I)
    for i ∈ axes(I, 1)
        f = f₀ - ((i - 1) * Δf / nf)
        ξ = round(Int, 𝓓 * dm * (f^-2 - f₀^-2) / δt)
        @inbounds for j ∈ eachindex(X)
            @inbounds jj = j + ξ
            if jj < nt
                X[j] += I[CartesianIndex(i, jj)]
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
