# returns the list of solver command-line options
function _get_options_list(options::Dict{AbstractString,Any})
    options_list = Array(AbstractString, 2*length(options))
    count = 0
    for (k,v) in options
        options_list[count+=1] = "--" * k
        if !isempty(v)
            options_list[count+=1] = string(v)
        end
    end
    options_list[1:count]
end