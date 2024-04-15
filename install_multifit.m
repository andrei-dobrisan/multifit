%script to install multifit

%first find MATLAB version

str_vers = version('-release');

year_vers = str2num(str_vers(1:end-1));

type_vers = str_vers(end);

went_ok = 1;

str_multifit = which('multifit');

if isempty(str_multifit)

	try

		if year_vers > 2017 || (year_vers == 2017 && type_vers == 'b')

			if ismac
				unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-mac.zip');
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ':')-1) '/multifit'];
				mkdir(pth_folder);
				movefile('multifit-mac/*', pth_folder);
				rmdir multifit-mac s;
			elseif isunix
				unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-linux.zip');
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ':')-1) '/multifit'];
				mkdir(pth_folder);
				movefile('multifit-linux/*', pth_folder);
				rmdir multifit-linux s;
			elseif ispc
				unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-windows.zip');
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ';')-1) '\multifit'];
				mkdir(pth_folder);
				movefile('multifit-windows/*', pth_folder);
				rmdir multifit-windows s;
				cur = cd(pth_folder);
				system('VC_redist.x64.exe');
				delete VC_redist.x64.exe;
				cd(cur);
			else
				disp('Platform not supported');
				went_ok = 0;
			end

		else

			if ismac
				websave('multifit-mac.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-mac.zip');
				unzip('multifit-mac.zip');
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ':')-1) '/multifit'];
				mkdir(pth_folder);
				movefile('multifit-mac/*', pth_folder);
				rmdir multifit-mac s;
				delete multifit-mac.zip
			elseif isunix
				websave('multifit-linux.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-linux.zip');
				unzip('multifit-linux.zip');
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ':')-1) '/multifit'];
				mkdir(pth_folder);
				movefile('multifit-linux/*', pth_folder);
				rmdir multifit-linux s;
				delete multifit-linux.zip
			elseif ispc
				websave('multifit-windows.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-windows.zip');
				unzip('multifit-windows.zip');
				delete multifit-windows.zip
				var_pth = path;
				pth_folder = [var_pth(1:find(var_pth == ';')-1) '\multifit'];
				mkdir(pth_folder);
				movefile('multifit-windows/*', pth_folder);
				rmdir multifit-windows s;
				cur = cd(pth_folder);
				system('VC_redist.x64.exe');
				delete VC_redist.x64.exe;
				cd(cur);
			else
				disp('Platform not supported');
				went_ok = 0;
			end

		end

		if went_ok
			addpath(pth_folder);
			savepath;
			delete install_multifit.m
			clear cur pth_folder var_pth str_vers type_vers year_vers went_ok
		end

	catch

		msg = 'Installation failed. Likely you do not have write access to the top folder in your Matlab path.';

		disp(msg);

		msg = 'A manual install is possible. Just grab the relevant archive for your OS from https://github.com/andrei-dobrisan/multifit/releases, unzip it and ';

		disp(msg);

		msg = 'put the resulting folder in a path Matlab has access to.';

		disp(msg);

		delete install_multifit.m

		clear cur pth_folder var_pth str_vers type_vers year_vers went_ok

	end

else

	cur = cd(str_multifit(1:max(strfind(str_multifit, 'multifit')-1)));

	if exist('multifit-old', 'dir')
		delete('multifit-old/*');
	else
		mkdir('multifit-old');
	end

	movefile('*', 'multifit-old');

	if year_vers > 2017 || (year_vers == 2017 && type_vers == 'b')

		if ismac
			unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-mac.zip');
			movefile('multifit-mac/*');
			rmdir multifit-mac s;
		elseif isunix
			unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-linux.zip');
			movefile('multifit-linux/*');
			rmdir multifit-linux s;
		elseif ispc
			unzip('https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-windows.zip');
			movefile('multifit-windows/*');
			rmdir multifit-windows s;
			delete VC_redist.x64.exe;
		else
			disp('Platform not supported');
			went_ok = 0;
		end

	else

		if ismac
			websave('multifit-mac.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-mac.zip');
			unzip('multifit-mac.zip');
			movefile('multifit-mac/*');
			rmdir multifit-mac s;
			delete multifit-mac.zip
		elseif isunix
			websave('multifit-linux.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-linux.zip');
			unzip('multifit-linux.zip');
			movefile('multifit-linux/*');
			rmdir multifit-linux s;
			delete multifit-linux.zip
		elseif ispc
			websave('multifit-windows.zip','https://github.com/andrei-dobrisan/multifit/releases/download/1.0/multifit-windows.zip');
			unzip('multifit-windows.zip');
			delete multifit-windows.zip
			movefile('multifit-windows/*');
			rmdir multifit-windows s;
			delete VC_redist.x64.exe;
		else
			disp('Platform not supported');
			went_ok = 0;
		end

	end

	if went_ok
		cd(cur);
		delete install_multifit.m
		clear cur str_vers type_vers year_vers went_ok
	end

end

