using Test
using DirectDedispersion

@testset "DirectDedispersion.jl" begin
    open("./data/frb.fil") do s
        seek(s, 362)
        data = Array{UInt8}(read(s))
        data = reshape(data, 128, :)
        ts = DirectDedispersion.dd(
            data;
            f₀=499.21875,
            Δf=200.0,
            δt=1.31072e-3,
            dm=1000.0,
        )
        @test argmax(ts) == 11563
        @test maximum(ts) ≈ 4540.0
    end
end
