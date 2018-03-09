function x= ReadData(IND,opt)
	%% for 200ms(8e6)-449_6
	if opt.filesnclass(1)==449 && opt.filesnclass(2)==6
		sig_name = {'ble_all','bt_all','fhss1_all','fhss2_all',...
			'wifi1_all','wifi2_all'};
        pac = ceil(IND/449);
		obj = matfile(sig_name{pac});
		seg = mod((IND-1),449);
		x = obj.('x')(1 + 4e6*seg:8e6 + 4e6*seg, 1);
	end
	%% for 200ms(2e6)-499_6
	if opt.filesnclass(1)==499 && opt.filesnclass(2)==6
		sig_name = {'ble_all','bt_all','fhss1_all','fhss2_all',...
			'wifi1_all','wifi2_all'};
        pac = ceil(IND/499);
		obj = matfile(sig_name{pac});
		seg = mod((IND-1),499);
		x = obj.('x')(1 + 1e6*seg:2e6 + 1e6*seg, 1);
	end

	%% for 200ms(2e7)-390_9
	if opt.filesnclass(1)==390 && opt.filesnclass(2)==9
		file_nm=cell(40,1);% file name
		sig_name={'ambient','ble','bluetooth','fhss1_','fhss2_',...
			'wifi','wifi20mhz','wifi40mhz','zigbee'};
		for ii=1:10
			for jj=1:9
				file_nm{ii+(jj-1)*10}=[sig_name{jj} num2str(ii) ];
			end
		end
		pac=ceil(IND/39); % IND is 390*N_class
		obj=matfile(file_nm{pac});
		seg=mod((IND-1),39);
		x=obj.('x')(1+1e7*seg:2e7+1e7*seg,1);
	end

	%% for 20ms(2e6)-390_4
	if opt.filesnclass(1)==390 && opt.filesnclass(2)==4
		f=opt.filesnclass(1);
		c=opt.filesnclass(2);
		
		file_nm=cell(40,1);% file name

		sig_name={'ble','fhss1_','wifi40mhz','zigbee'};
		for ii=1:1 % how many packs to use
			for jj=1:c
				file_nm{ii+(jj-1)*c}=[sig_name{jj} num2str(ii) ];
			end
		end
		pac=ceil(IND/f); % IND total is f*c
		obj=matfile(file_nm{pac});
		seg=mod((IND-1),f);
		x=obj.('x')(1+1e6*seg:2e6+1e6*seg,1);
	end

	%% for 200ms(2e7)-770
	if opt.filesnclass(1)==770 && opt.filesnclass(2)==4
		nm0=cell(40,1);
		nm=cell(40,1);
		for ii=1:10
			nm0{ii}=['Ambient' num2str(ii) ];% mat file name
			nm{ii}=['Ambient' num2str(ii) ];% variable name
		end                
		for ii=10+(1:10)
			nm0{ii}=['Bluetooth' num2str(ii-10) ];
			nm{ii}=['Bt' num2str(ii-10) ];
		end
		for ii=20+(1:10)
			nm0{ii}=['wifi' num2str(ii-20) ];
			nm{ii}=['wifi' num2str(ii-20) ];
		end
		for ii=30+(1:10)
			nm0{ii}=['zigbee' num2str(ii-30) ];  
			nm{ii}=['zigbee' num2str(ii-30) ];
		end  

		pac=ceil(IND/77);
		obj=matfile(nm0{pac});
		seg=mod((IND-1),77);
		x=obj.(nm{pac})(1+5e6*seg:2e7+5e6*seg,1);
	end      
end