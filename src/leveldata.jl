struct LevelData
    data
    levelno::Vector{Int}
end

LevelData(data) = LevelData(data,repeat([2],size(data,2)))
