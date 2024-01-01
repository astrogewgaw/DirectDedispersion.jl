using Test
using DirectDedispersion

@testset "DirectDedispersion.jl" begin
    open("./data/frb.fil") do s
        seek(s, 360)
        data = Array{UInt8}(read(s))
        data = reshape(data, 128, :)

        Δf = 200.0
        dm = 1000.0
        f₀ = 499.21875
        δt = 1.31072e-3

        ts = DirectDedispersion.dd(
            data;
            f₀=f₀,
            Δf=Δf,
            δt=δt,
            dm=dm,
        )

        nt = size(ts, 1)
        t = range(0.0, nt * δt, nt)

        @test argmax(ts) == 3902
        @test maximum(ts) ≈ 8472.0
        @test t[argmax(ts)] ≈ 5.0 atol = 1.0
    end
end
