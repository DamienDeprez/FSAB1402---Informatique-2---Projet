fonction {InterpreteAux Partition Note Duree DemiTons Acc}
	local PartitionFlat in

	%Flatten Partition
	PartitionFlat=Flatten{Partition}

	%Case of Partition type
	case PartitionFlat
	of nil then Acc	
	[] Nom#Octave then
		if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:Nom octave:Octave alteration:'#') Duree DemiTons}|Acc}
		else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end

	[] Atom then
		case {AtomToString Atom}
		of [N] then
			if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:N octave:4 alteration:none) Duree DemiTons}|Acc}
			else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
		[] [N O] then
			if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:N octave:O alteration:none) Duree DemiTons}|Acc}
			else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
	end
	[] note(nom:Nom octave:Octave alteration:Alteration) then
		{InterpreteAux nil nil Duree DemiTons {PartitionFlat Duree DemiTons}|Acc}

	[] muet(TPartition) then 
		{InterperteAux TPartition silence Duree DemiTons Acc}

	[] etirer(facteur:F TPartition) then
		{InterperteAux TPartition nil Duree*F DemiTons Acc}

	[] duree(seconde:S TPartition) then 
		local TPartitionFlat DureeTot DureeF DureeIniF in 
			% Flat Partition
			%Appel fonction DureeTot
			{Int.toFloat Duree DureeIniF} %cast en float pour la division
			{Int.toFloat S DureeF}
			{InterpreteAux TPartitionFlat nil DureeIniF*DureeF/DureeTot DemiTons Acc}
		end

	[] bourdon(note:Note Partition) then 
		{InterpreteAux Partition Note Duree DemiTons Acc}

	[] transpose(demitons:DemiTons Partition) then
		{InterpreteAux Partition nil Duree DemiTons Acc}

	[] H|T then
		{InterpreteAux T nil Duree DemiTons {InterpretAux H nil Duree DemiTons Acc}}
	end
end

%partition doit être Flat
fonction {DureeTot Partition Acc}
	local DureeNote in
	case Partition
	of nil then Acc
	[] H|T then {DureeTot Partition Acc+1.0}
