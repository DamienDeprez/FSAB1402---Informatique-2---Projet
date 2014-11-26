% Vous ne pouvez pas utiliser le mot-cle 'declare'.
local Mix Interprete Projet CWD in
	% CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
	% modifiez sa valeur pour correspondre à votre système.
	% CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}%Zélie
	CWD = {Property.condGet 'testcwd' '/media/damien/Home/Damien/Documents/UCL/FSA12-BA/Projet_Informatique_2/'}%DAMIEN
	% Projet fournit quatre fonctions :
	% {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
	% {Projet.readFile FileName} = AudioVector OR error(...)
	% {Projet.writeFile FileName AudioVector} = ok OR error(...)
	% {Projet.load 'music_file.dj.oz'} = La valeur oz contenue dans le fichier chargé (normalement une <musique>).
	%
	% et une constante :
	% Projet.hz = 44100, la fréquence d'échantilonnage (nombre de données par seconde)
	[Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

	local
		Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
	in
	% Mix prends une musique et doit retourner un vecteur audio.
  	fun {Mix Interprete Music}
    	Audio
    end

    % Interprete doit interpréter une partition
    fun {Interprete Partition}

		local Flatten NoteToEchantillon Reverse InterpreteAux in

			fun{Flatten Partition}
				local 
					fun{FlattenAux List A}
					case List of nil then A
					[] H|T then {FlattenAux H {FlattenAux T A}}
					else List|A end %cas ou List n'est pas une liste et est donc un élément 
					end % fin case List
				in 
				{FlattenAux Partition nil}
				end % fin local
			end % fin fun{Flatten Partition}

			fun{NoteToEchantillon Note Duree DemiTons}
				local Octave Hauteur Nom I1 Ech in
				Nom=note.nom
				Octave=note.octave
					case Nom 
						of a then I1=0
						[] b then I1=2 %2demitons entre a et b
						[] c then I1=~9 %-7-1 demitons entre a et c
						[] d then I1=~7 %-5-2 demitons entre a et d
						[] e then I1=~5 %-4-1 demitons entre a et e
						[] f then I1=~4 %-2-2 demitons entre a et f
						[] g then I1=~2 %-2 demitons entre a et g
					end % fin case Nom
				Hauteur= (Octave-4)*12 + I1 + DemiTons
				Ech=echantillon(hauteur:Hauteur duree:Duree instrument:none)
				end % fin local Octave Hauteur Nom I1 Ech
			end % fin fun{NoteToEchantillon Note Duree DemiTons}

			fun {Reverse Partition}
				local RerverseAux in
					fun{ReverseAux S A}
						case S of nil then A
							[] H|T then {ReverseAux T H|A}
						end % fin case S
					end % fin fun{ReverseAux S A}
					{ReverseAux Partition nil}
	   			end % fin local ReverseAux
			end % fin fun {Reverse Partition}

			fun {DureeTot Partition}
				local 
					fun{DureeTotAux Part Acc Inc}
						case Part 
						of nil then Acc
						[] H|T then 
							case H
							of note(nom:Nom octave:Octave alteration:Alteration) then {DureeTotAux T Acc+Inc Inc}
							of muet(Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
							of duree(secondes:Seconde Partition) then {DureeTotAux T Acc+Seconde Inc}
							of etirer(facteur:Facteur Partition) then {DureeTotAux T {DureeTotAux Partition Acc Facteur*Inc} Inc}
							of bourdon(note:Note Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
							of transpose(demitons:Entier Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
							end % fin case H
						end % fin case Part
					end % fin fun{DureeTotAux Part Acc Inc}
				in
				{DureeTot Partition 0.0 1.0}
				end % fin local 
			end % fin fun {DureeTot Partition}

			fun {InterpreteAux Partition Note Duree DemiTons Acc}
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
					end % fin case {AtomToString Atom}
				[] note(nom:Nom octave:Octave alteration:Alteration) then
					{InterpreteAux nil nil Duree DemiTons {PartitionFlat Duree DemiTons}|Acc}

				[] muet(TPartition) then 
					{InterperteAux TPartition silence Duree DemiTons Acc}

				[] etirer(facteur:F TPartition) then
					{InterperteAux TPartition nil Duree*F DemiTons Acc}

				[] duree(seconde:S TPartition) then 
					local TPartitionFlat DureeTot DureeTotF DureeF DureeIniF IsFloat in 
						TPartitionFlat={Flatten TPartition}
						DureeTot={DureeTot TPartitionFlat}
						{Float.is DureeTot IsFloat}
						{Int.toFloat Duree DureeIniF} %cast en float pour la division
						{Int.toFloat S DureeF}
						if IsFloat then
						{InterpreteAux TPartitionFlat nil DureeIniF*DureeF/DureeTot DemiTons Acc}
						else
						{Int.toFloat DureeTot DureeTotF}
						{InterpreteAux TPartitionFlat nil DureeIniF*DureeF/DureeTotF DemiTons Acc}
						
					end % fin local TPartitionFlat DureeTot DureeF DureeIniF

				[] bourdon(note:Note Partition) then 
					{InterpreteAux Partition Note Duree DemiTons Acc}

				[] transpose(demitons:DemiTons Partition) then
					{InterpreteAux Partition nil Duree DemiTons Acc}

				[] H|T then
					{InterpreteAux T nil Duree DemiTons {InterpretAux H nil Duree DemiTons Acc}}
				end % fin case Partition
			end % fin fun {InterpreteAux Partition Note Duree DemiTons Acc}
			{InterpreteAux Partition nil 1 0 nil}
		end % fin local Flatten NoteToEchantillon Reverse InterpreteAux
	end % fin fun {Interprete Partition}

	local 
		Music = {Projet.load CWD#'joie.dj.oz'}
	in
		% Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
		% vous devez mixer une musique qui démontre les fonctionalités de votre
		% programme.
		%
		% Si votre code devait ne pas passer nos tests, cet exemple serait le
		% seul qui ateste de la validité de votre implémentation.
		{Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
	end
end
