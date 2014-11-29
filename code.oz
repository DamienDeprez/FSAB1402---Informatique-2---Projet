% Vous ne pouvez pas utiliser le mot-clé 'declare'.
local Mix Interprete Projet CWD in
<<<<<<< HEAD
	% CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
	% modifiez sa valeur pour correspondre à votre système.
	 %CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}%Zélie
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
=======
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
  % CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}%Zélie
   CWD = {Property.condGet 'testcwd' '/media/damien/Home/Damien/Documents/UCL/FSA12-BA/Projet_Informatique_2/'}%DAMIEN
>>>>>>> origin/master

   % Si vous utilisez Mozart 1.4, remplacez la ligne précédente par celle-ci :
   % [Projet] = {Link ['Projet2014_mozart1.4.ozf']}
   %
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
	 local Frequence EchantillonToVecteurAudio Clip RepetitionDuree RepetitionNfois PI=3.14159265359 in
	    fun{Frequence Hauteur}
	       R HtoFloat in
	       {Int.toFloat Hauteur HtoFloat}
	       {Number.pow 2.0 (HtoFloat/12.0) R}
	       R*440.0
	    end % fin de la fonction frequence

	    fun{EchantillonToVecteurAudio Echantillon}
	       local EchantillonToVecAux F in
		  F={Frequence Echantillon.hauteur} %Frequence en fonction de la hauteur de l'echantillon
		  fun{EchantillonToVecAux Echantillon Inc Vec} %Vec = vecteur Audio a renvoyé, Inc= increment
		     local Frac Sin Ai IsFloat DureeF in
			%{Value.'>' Inc (Echantillon.duree)*44100.0 B}
			{Float.is (Echantillon.duree) IsFloat} % test si la duree de l'echantillon est un float
			if IsFloat then DureeF=(Echantillon.duree) % si oui, on ne fait rien
			else {Int.toFloat (Echantillon.duree) DureeF} end
			Frac=(2.0*PI*F*Inc)/44100.0
			{Float.sin Frac Sin}
			Ai=0.5*Sin
			%{Number.'*' 0.5 Sin Ai} 
			if Inc>DureeF*44100.0 then Vec %Si on depasse la valeur d'echantillonage, notre Vecteur est complet
			else 
			   {EchantillonToVecAux Echantillon Inc+1.0 Ai|Vec}%On garde le meme echantillon
			end % fin du %if
		     end % fin du local pour Frac Sin Ai et B
		  end % fin de la fonction EchantillonToVecAux
		  {EchantillonToVecAux Echantillon 0.0 nil}
	       end % fin du local pour F et EchantillonToVecAux
	    end % fin fonction EchantillonToVecteurAudio

	    fun{Clip Up Down VecteurAudio}
	       local 
		  fun{ClipAux VecteurAudio Acc}
		     case VecteurAudio 
		     of nil then Acc
		     [] H|T then 
			if H<Down then {ClipAux T Down|Acc}
			elseif H>up then {ClipAux T Up|Acc}
			else {ClipAux T H|Acc}
			end%fin du %if
		     end%fin du case VecteurAudio
		  end %fin de la fonction ClipAux
	       in
		  {Reverse {ClipAux VecteurAudio nil}}
	       end%fin du local ClipAux
	    end%Fin de la fonction Clip

	    fun{RepetitionNfois N Music}
	       local
		  fun{RepetitionAux N Acc}
		     if N==0 then Acc
		     else {RepetitionAux N-1 {Mix Interprete Music}|Acc}
		     end % fin if
		     end % fin RepetitionAux
		  in
		     {RepetitionAux N nil}
		  end % fin local
	       end % fin RepetitionNfois
	    
	       {EchantillonToVecteurAudio {Interprete [a3]}.1}
	   % Audio
	    end
	 end

      % Interprete doit interpréter une partition
	 fun {Interprete Partition}
	    local Flatten NoteToEchantillon Reverse InterpreteAux DureeTot in
	       fun{Flatten Partition}
		  local 
		     fun{FlattenAux List A}
			case List of nil then A
			[] H|T then {FlattenAux H {FlattenAux T A}}
			else List|A end %cas ou List n'est pas une liste et est donc un élément 
		     end % fin FLattenAux List
		  in 
		     {FlattenAux Partition nil}
		  end % fin local
	       end % fin fun{Flatten Partition}
	    
	       fun{NoteToEchantillon Note Duree DemiTons}
		  local Octave Hauteur Nom I1 Ech in
		     case Note of note(nom:Name octave:Oct alteration:Alt) then
			Nom=Note.nom
			Octave=Note.octave
			case Nom 
			of a then I1=0
			[] b then I1=2 % 2 demitons entre a et b
			[] c then I1=~9 %-7-2 demitons entre a et c
			[] d then I1=~7 %-5-2 demitons entre a et d
			[] e then I1=~5 %-4-1 demitons entre a et e
			[] f then I1=~4 %-2-2 demitons entre a et f
			[] g then I1=~2 %-2 demitons entre a et g
			end % fin case Nom
			Hauteur= (Octave-4)*12 + I1 + DemiTons
			Ech=echantillon(hauteur:Hauteur duree:Duree instrument:none)
		     [] silence then Ech=silence(duree:Duree)
		     end%fin du case
		  end % fin local Octave Hauteur Nom I1 Ech
	       end % fin fun{NoteToEchantillon Note Duree DemiTons}

	       fun {Reverse Partition}
		  local ReverseAux in
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
			   [] muet(Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
			   [] duree(secondes:Seconde Partition) then {DureeTotAux T Acc+Seconde Inc}
			   [] etirer(facteur:Facteur Partition) then {DureeTotAux T {DureeTotAux Partition Acc Facteur*Inc} Inc}
			   [] bourdon(note:Note Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
			   [] transpose(demitons:Entier Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
			   [] Nom#Octave then {DureeTotAux T Acc+Inc Inc}
			   [] Atom then {DureeTotAux T Acc+Inc Inc}
			   end % fin case H
			end % fin case Part
		     end % fin fun{DureeTotAux Part Acc Inc}
		  in
		     {DureeTotAux Partition 0.0 1.0}
		  end % fin local 
	       end % fin fun {DureeTot Partition}

	       fun {InterpreteAux Partition Note Duree DemiTons Acc}
				%Case of Partition type
		  case Partition
		  of nil then Acc	
		  [] Nom#Octave then
		     if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:Nom octave:Octave alteration:'#') Duree DemiTons}|Acc}
		     else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end

		  [] note(nom:Nom octave:Octave alteration:Alteration) then
		     if Note==nil then 
			{InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Partition Duree DemiTons}|Acc}
		     else 
			{InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end

		  [] muet(TPartition) then 
		     {InterpreteAux {Flatten TPartition} silence Duree DemiTons Acc}

		  [] etirer(facteur:F TPartition) then
		     local DureeF IsFloat in
			{Float.is Duree IsFloat}
			if IsFloat then {InterpreteAux {Flatten TPartition} Note Duree*F DemiTons Acc}
			else {Int.toFloat Duree DureeF}
			   {InterpreteAux {Flatten TPartition} Note DureeF*F DemiTons Acc} end
		     end
		  [] duree(seconde:S TPartition) then 
		     local TPartitionFlat DureeTotale DureeTotF DureeF DureeIniF IsFloat in 
			TPartitionFlat={Flatten TPartition}
			DureeTotale={DureeTot TPartitionFlat}
			{Float.is DureeTotale IsFloat}
			{Int.toFloat Duree DureeIniF} %cast en float pour la division
			if IsFloat then
			   {InterpreteAux TPartitionFlat Note DureeIniF*DureeF/DureeTotale DemiTons Acc}
			else
			   {Int.toFloat DureeTotale DureeTotF}
			   {InterpreteAux TPartitionFlat Note DureeIniF*DureeF/DureeTotF DemiTons Acc} end
						
		     end % fin local TPartitionFlat DureeTot DureeF DureeIniF

		  [] bourdon(note:NoteB TPartition) then 
		     {InterpreteAux {Flatten TPartition} NoteB Duree DemiTons Acc}

		  [] transpose(demitons:DemiTons TPartition) then
		     {InterpreteAux {Flatten TPartition} Note Duree DemiTons Acc}

		  [] H|T then
		     {Flatten {InterpreteAux T Note Duree DemiTons {InterpreteAux H Note Duree DemiTons nil}|Acc}}

		  [] Atom then
		     case {AtomToString Atom}
		     of [N] then
			if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:Atom octave:4 alteration:none) Duree DemiTons}|Acc}
			else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
		     [] [N O] then
			if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:none) Duree DemiTons}|Acc}
			else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
		     end % fin case {AtomToString Atom}
		  end % fin case Partition
	       end % fin fun {InterpreteAux Partition Note Duree DemiTons Acc}
	       {Reverse {InterpreteAux {Flatten Partition} nil 1 0 nil}}
	    
	    end % fin local Faltten NoteToEchantillon Reverse InterpreteAux DureeTot
	 end % fin fun {Interprete Partition}
      end % fin local Audio

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
