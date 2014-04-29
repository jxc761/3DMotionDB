% script to pack all jpg to gif
function to_gifs(root_path, fmt, output_path, delaytime)

    filelist = dir(root_path);

    for i = 1 : numel(filelist)
        file=filelist(i);

        if file.isdir && ~strcmp(file.name,'.') && ~strcmp(file.name,'..')
            cur_path = fullfile(root_path, file.name);
            %cur_output_path = output_path;
            cur_output_path = fullfile(output_path, file.name);
            mkdir(cur_output_path);
            to_gifs(cur_path, fmt, cur_output_path, delaytime);
        end

    end

    img_list = dir(fullfile(root_path, ['*.' fmt]));
    if numel(img_list) < 1
        return
    end

    [~, name, ~] = fileparts(root_path);
    gif_path = fullfile(output_path, [name '.gif']);

    img_list = sort_nat({img_list.name});
    to_gif(root_path, img_list, gif_path, delaytime);

end


function to_gif(input_path, files, gif_path, delaytime)
    disp(['create gif: ' gif_path])
    
    for i = 1 : numel(files)
        filename = fullfile(input_path, files{i});
        
        img = imread(filename);
        [A,map] = rgb2ind(img, 256);
        if i == 1
            imwrite(A, map,gif_path,'gif','LoopCount',Inf,'DelayTime',delaytime);
        else
            imwrite(A, map, gif_path,'gif','WriteMode','append','DelayTime',delaytime);
        end
    end
    
end





