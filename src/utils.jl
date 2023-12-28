"""
    get_options_list(options::Dict{AbstractString,Any})
    
Takes a dictionary of options and returns a list of strings of the form "-option value".
"""
function get_options_list(options::Dict{AbstractString,Any})
    vec_len = 2 * length(options)
    if "verbose" in keys(options) && options["verbose"] == :none
        vec_len -= 2
    end
    options_list = Array{AbstractString}(undef, vec_len)
    count = 0
    for (k,v) in options
        if k == "verbose" && v == :none
            continue
        end
        options_list[count+=1] = "-" * k
        options_list[count+=1] = string(v)
    end
    return options_list[1:count]
end

"""
    invalid_option_error(option::AbstractString, option_selected::Symbol, option_constant::Vector)
    
Formats and throws an error for an invalid option.
"""
function invalid_option_error(
    option::AbstractString, option_selected::Symbol, option_constant::Vector
) 
    err = ArgumentError("""Invalid $option=:$option_selected option selected.
    Valid options are: \n\t:default\n$(list_options(option_constant))
    """)
    throw(err)
end

"""
    list_options(option_constant::Vector)
    
Takes the list of options and returns a string of them separated by new line characters.
"""
function list_options(option_constant::Vector)
        # Prepend a colon to each option to appear as a Symbol
        option_constant = ["\t:" * String(option) for option in option_constant]
        return join(option_constant, "\n")
end
