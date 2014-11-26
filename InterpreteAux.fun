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
		{InterperteAux TPartition silence 1 0 Acc}

	[] etirer(facteur:F TPartition) then
		{InterperteAux TPartition nil Duree*F 0 Ac}

	[] duree(seconde:S TPartition) then 
		local TPartitionFlat DureeTot DureeF DureeIniF in 
			% Flat Partition
			%Appel fonction DureeTot
			{Int.toFloat Duree DureeIniF} %cast en float pour la division
			{Int.toFloat S DureeF}
			{InterpreteAux TPartitionFlat nil DureeIniF*DureeF/DureeTot 0 Acc}
		end

	[] bourdon(note:Note Partition) then 
		{InterpreteAux Partition Note 1 0 Acc}

	[] transpose(demitons:DemiTons Partition) then
		{InterpreteAux Partition nil 1 DemiTons Acc}
	end
end

fonction {DureeTot Partition Acc}
	local DureeNote in
	case of nil then Acc

