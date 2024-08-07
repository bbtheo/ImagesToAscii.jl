function read_photo(path, ratio = 1)
    photo = imresize(load(path),ratio=ratio)
    photo = Gray.(photo)
    array = convert(Array{Float64},photo) 
    return array
end

function shift_matrix(matrix::Array{T,2}, i_just::Int, j_just::Int) where T
    rows, cols = size(matrix)
    new_matrix = zeros(T, rows, cols)
    
    for i in 1:rows
        for j in 1:cols
            new_i = i + i_just
            new_j = j + j_just
            
            if new_i >= 1 && new_i <= rows && new_j >= 1 && new_j <= cols
                new_matrix[i, j] = matrix[new_i, new_j]
            end
        end
    end
    
    return new_matrix
end

function map_to_char(value, levels)
    index = clamp(value, 1, length(levels)) 
    return levels[index]*levels[index]
end

function rescale_photo(photo_array, n_level::Integer)
    photo_array = photo_array*(-n_level)
    photo_array = photo_array .+ (n_level+1)
    return Int8.(floor.(photo_array))
end

function encode_photo(photo_array, write_path::String ="output.txt", encode_levels::String = " .:-=+*?#%@")
    photo_array = rescale_photo(photo_array, length(encode_levels))

    #hor_mat = abs.(shift_matrix(photo_array, 1, 0) - photo_array)
    #ver_mat = abs.(shift_matrix(photo_array, 0, 1) - photo_array)

    #mat_1 = map(x -> map_threshold(x, 0.90, "||"), ver_mat)
    #mat_2 = map(x -> map_threshold(x, 0.90, "--"), hor_mat)

    #photo_array = map(x -> map_to_char(x, encode_levels), photo_array)

    photo_array = coalesce.(mat_1, mat_2, photo_array)
    output_string = join(map(join, eachrow(photo_array)), '\n')

    open(write_path, "w") do file
        write(file, output_string)
    end

end
