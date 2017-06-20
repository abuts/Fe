function id = direction_id(direction)

persistent dir_map;
if isempty(dir_map)
    dir_map = containers.Map();
    dir_map('100') = '<100>';
    dir_map('010') = '<100>';
    dir_map('001') = '<100>';
    %
    dir_map('110') = '<110>';
    dir_map('1-10') = '<110>';
    dir_map('101') = '<110>';
    dir_map('10-1') = '<110>';
    dir_map('011') = '<110>';
    dir_map('01-1') = '<110>';
    %
    dir_map('111') = '<111>';
    dir_map('11-1') = '<111>';
    dir_map('1-1-1') = '<111>';
    dir_map('1-11') = '<111>';
end

dir_id = [num2str(direction(1)),num2str(direction(2)),num2str(direction(3))];
id = dir_map(dir_id);
