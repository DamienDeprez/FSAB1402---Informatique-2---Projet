% Vous ne pouvez pas utiliser le mot-clé 'declare'.
local Mix Interprete Projet CWD in

   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
    CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}%Zélie
  % CWD = {Property.condGet 'testcwd' '/media/damien/Home/Damien/Documents/UCL/FSA12-BA/Projet_Informatique_2/'}%DAMIEN

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
<<<<<<< HEAD
	 local MixAux ListEchantillonToAudio EchantillonToAudio Add Frequence Clip RepetitionNfois RepetitionDuree Echo Merge Fondu Pi=3.1415 in
		
		%%Fonction Add
		%Arguments: Deux listes  L1 et L2 remplies float
		%Valeur: Nouvelle liste de la taille de la liste passee en argument la plus longue. Chaque element = somme des elements des deux listes. La liste la plus courte est allongee par des 0.
=======
	 local MixAux ListEchantillonToAudio EchantillonToAudio Add Frequence Clip RepetitionNfois RepetitionDuree Echo Merge Fondu Couper FonduEnchaine Pi=3.1415 in

>>>>>>> origin/master
	    fun{Add List1 List2}
	       local AddAux S1 S2 in
		  S1={Length List1}
		  S2={Length List2}
		  fun{AddAux L1 L2 Acc}
		     case L1
		     of nil then{Browse 'add fin'} Acc
		     [] H1|T1 then
			case L2
			of nil then {AddAux T1 nil H1|Acc}
			[] H2|T2 then {AddAux T1 T2 (H1+H2)|Acc}
			end % end case L2
		     end % end case L1
		  end % end fun AddAux
		  if S1>S2 then{Reverse {AddAux List1 List2 nil}}
		  else {Reverse {AddAux List2 List1 nil}}
		  end % end if S1>S2
	       end %end local
	    end % en fun Add

	    %%Fonction Frequence
		%Argument
	    fun{Frequence Hauteur}
	       local R HtoFloat in
		  {Int.toFloat Hauteur HtoFloat}
		  {Number.pow 2.0 (HtoFloat/12.0) R}
		  R*440.0
	       end %fin du local
	    end%fin de la fonction frequence

	    fun{EchantillonToAudio Echantillon Facteur Acc}
	       local F EchToAudio in
		  fun{EchToAudio Ech Fac I Vec Lissage}
		     local IsFloat DureeF Sin in
			case Ech
			of silence(duree:S) then
			   {Float.is S IsFloat}
			   if IsFloat then DureeF=S
			   else {Int.toFloat S DureeF} end
			   if I>=DureeF*44100.0 then Vec
			   else {EchToAudio Ech Fac I+1.0 0.0|Vec 0.0} end
			[] echantillon(hauteur:Hauteur duree:S instrument:Instrument) then
			   F={Frequence Echantillon.hauteur}
			   {Float.is S IsFloat}
			   if IsFloat then DureeF=S
			   else {Int.toFloat S DureeF} end
			   {Float.sin (2.0*Pi*I*F)/44100.0 Sin}
			   if I>=DureeF*44100.0 then Vec
			   else
			      % Ajout du lissage
			      if I<500.0 then {EchToAudio Ech Fac I+1.0 (Fac*0.75*Sin*I/500.0)|Vec Lissage+1.0}
			      elseif I>(DureeF*44100.0-1000.0) then { EchToAudio Ech Fac I+1.0 (Fac*0.5*Sin*(I-DureeF*44100.0)/(~1000.0))|Vec Lissage-1.0}
			      else {EchToAudio Ech Fac I+1.0 (Fac*0.5*Sin)|Vec 1000.0 } end % fin if lissage
			   end % fin if dans le vecteur
			end % fin case echantillon
		     end % fin local
		  end % fin EchToAudio
		  {EchToAudio Echantillon Facteur 0.0 Acc 0.0}
	       end % fin local
	    end % fin EchantillonToAudio

	    fun{ListEchantillonToAudio Echantillon Facteur}
	       local LeToAudio in
		  fun{LeToAudio ListEch Acc Facteur}
		     case ListEch
		     of nil then Acc
		     [] H|T then {LeToAudio T {EchantillonToAudio H Facteur Acc} Facteur}
		     end % fin case
		  end	% fin fun {LeToAudio}
		  {List.reverse {LeToAudio Echantillon nil Facteur}}
	       end % fin local
	    end % fin fun{ListEchantillonToAudio}

	    fun{Clip Up Down MusicClip Facteur}
	       local ClipAux
		  fun{ClipAux VecteurAudio Acc}
		     case VecteurAudio 
		     of nil then Acc
		     [] H|T then 
			if H<Down then {ClipAux T Down|Acc}
			elseif H>Up then {ClipAux T Up|Acc}
			else {ClipAux T H|Acc}
			end%fin du %if
		     end%fin du case VecteurAudio
		  end %fin de la fonction ClipAux
	       in
		  {List.reverse {ClipAux {MixAux Interprete MusicClip Facteur  nil} nil }}
	       end%fin du local ClipAux
	    end%Fin de la fonction Clip

	    fun{RepetitionNfois N Music Facteur}
	       local
		  fun{RepetitionAux N Acc}
		     if N==0 then Acc
		     else{RepetitionAux N-1 {MixAux Interprete Music Facteur nil}|Acc}
		     end % fin if else
		  end % fin RepetitionAux
		  
	       in
		  {List.flatten {RepetitionAux N nil}}
	       end % fin local
	    end % fin RepetitionNfois

	    fun{RepetitionDuree Duree Musique Facteur}
	       local RepetitionAux L={MixAux Interprete Musique Facteur nil} in
		  fun{RepetitionAux L1 Size Acc}
		     case L1
		     of nil andthen Size=<0 then Acc
		     [] nil andthen Size>0 then{RepetitionAux L Size Acc}
		     [] H|T  andthen Size>0 then{RepetitionAux T Size-1 H|Acc}
		     [] H|T andthen Size==0 then Acc
		     end % fin case L1
		  end % fin RepetitionAux
		  {RepetitionAux L Duree*44100 nil}
	       end % fin local
	    end % fin RepetitionDuree

	    fun{Echo Duree Decadence Repetition Music Facteur}
	       local EchoAux in
		  fun{EchoAux Music R Acc}
		     local Intensity Reste B C D Vec in
			if (Decadence==1.0) then Intensity={Floor 100.0/({IntToFloat Repetition}+1.0)}/100.0
			else
			   Reste={Pow Decadence {IntToFloat Repetition+1}}
			   B={Pow Decadence {IntToFloat R}}
			   C={Pow 2.0 {IntToFloat R}}
			   D=B+{Ceil Reste/C*100.0}/100.0
			   Intensity={Round 100.0*D}/100.0 end
			Vec={MixAux Interprete [voix([silence(duree:{IntToFloat R-1}*Duree)]) Music] Facteur*Intensity nil}
			if R==Repetition+1 then {Add Acc Vec}
			else{EchoAux Music R+1 {Add Acc Vec}} end
		     end
		  end
		  {EchoAux Music 1 nil}
	       end
	    end
	    
	    fun{Merge MusicWithIntensity Acc Facteur}
	       case MusicWithIntensity
	       of nil then Acc
	       [] H|T then{Merge T {Add {MixAux Interprete H.2 Facteur*H.1 nil} Acc}Facteur}
	       end
	    end

	    fun{Fondu Ouverture Fermeture Music Facteur}
	       local DureeTot VecAudio FonduAux Douv=Ouverture*44100.0 Dferm in
		  VecAudio={MixAux Interprete Music Facteur nil}
		  DureeTot= {IntToFloat{Length VecAudio}}
		  Dferm=DureeTot-Fermeture*44100.0
		  fun{FonduAux T VA Acc}
		     local Dt={IntToFloat T} in
			case VA
			of nil then {Reverse Acc}
			[] H|Q andthen Dt<Douv then {FonduAux T+1 Q ((H*Dt)/Douv)|Acc}
			[] H|Q andthen Dt>=Dferm then {FonduAux T+1 Q (H*(Dt-DureeTot))/(Dferm-DureeTot)|Acc}
			[] H|Q then {FonduAux T+1 Q H|Acc}
			end % fin case
		     end % fin local
		  end % fin FonduAux
		  if (Ouverture+Fermeture)*44100.0>DureeTot then VecAudio
		  else {FonduAux 0 VecAudio nil} end
	       end % fin local
	    end % fin Fondu
	    
	       
	    fun{Couper In Out Musique Facteur}
	       local VecAudio Size Decompte Debut=In*44100.0 Fin=Out*44100.0 in
		  VecAudio={MixAux Interprete Musique Facteur nil}
		  Size={IntToFloat {Length VecAudio}}
		  fun{Decompte Begin End Vec Acc}
		     case Vec 
		     of nil then Acc
		     [] H|T then
			if Begin=<1.0 andthen End>0.0 then {Decompte Begin End-1.0 T H|Acc} % Begin=<1.0 pour inclure la valeur du pt de départ
			elseif End=<0.0 then Acc
			else {Decompte Begin-1.0 End-1.0 T Acc}
			end
		     end
		  end % fin Decompte
		  if Debut<0.0 then
		     if Fin<0.0 then
			if Fin<Debut then {Browse error} nil
			else{MixAux Interprete [voix([silence(duree:(Fin-Debut))])] Facteur nil} end
		     else
			if Fin>Size then{MixAux Interprete [voix([silence(duree:~Debut)]) Musique voix([silence(duree:(Size-Fin))])] Facteur nil}
			elseif Fin==Size then {MixAux Interprete [voix([silence(duree:~Debut)]) Musique] Facteur nil}
			else{Append {MixAux Interprete [voix([silence(duree:~Debut)])] Facteur nil} {Reverse{Decompte 0.0 Fin VecAudio nil}}} end
		     end
		  else
		     if Fin<Debut then {Browse error} nil
		     elseif Fin==Debut then nil
		     else
			if Fin>Size then{MixAux Interprete [Musique voix([silence(duree:(Size-Fin))])] Facteur nil}
			elseif Fin==Size then VecAudio
			else {Reverse{Decompte Debut Fin VecAudio nil}} end
		     end
		  end
	       end
	    end


	    fun{FonduEnchaine Duree Music1 Music2 Facteur}
	       local VecAudio1 VecAudio2 DureeMusic1 VecSilence VecAudio3 in
		  VecAudio1={MixAux Interprete [fondu(ouverture:0.0 fermeture:Duree Music1)] Facteur nil}
		  VecAudio2={MixAux Interprete [fondu(ouverture:Duree fermeture:0.0 Music2)] Facteur nil}
		  DureeMusic1={IntToFloat {Length VecAudio1}}/44100.0
		  {Browse DureeMusic1-Duree}
		  VecSilence={MixAux Interprete [voix([silence(duree:(DureeMusic1-Duree))])] Facteur nil}
		 % Fondu1=fondu(ouverture=0.0, fermeture={IntToFloat L1}-(Duree*44100.0) Music1) 
		 % Fondu2=fondu(ouverture=(Duree*44100.0) fermeture=0.0 Music2)
		  {Browse 'debut append'}
		  VecAudio3={Append VecSilence VecAudio2}
		  {Browse 'append fin'}
		  {Browse 'add debut'}
		  {Add VecAudio1 VecAudio3}
	       end % fin local
	    end % fin Fondu
      
	    fun{MixAux Interprete  Music Facteur  Acc}
	       case Music
	       of nil then {Browse 'fin mix'}{Flatten Acc}
	       [] voix(Voix) then {ListEchantillonToAudio Voix Facteur}
	       [] partition(Partition) then {ListEchantillonToAudio {Interprete Partition} Facteur}
	       [] wave(File) then {Projet.readFile File}
	       [] renverser(MusicR) then{List.reverse {MixAux Interprete MusicR Facteur nil}}
	       [] repetition(nombre:N MusicR) then{RepetitionNfois N MusicR Facteur}
	       [] repetition(duree:S MusicR) then {RepetitionDuree S MusicR Facteur}
	       [] clip(bas:Bas haut:Haut MusiC)  then {Clip Haut Bas MusiC Facteur}
	       [] echo(delai:S MusicE) then {Echo S 1.0 1 MusicE Facteur}
	       [] echo(delai:S decadence:D MusicE)then{Echo S D 1 MusicE Facteur}
	       [] echo(delai:S decadence:D repetition:R MusicE)then {Echo S D R MusicE Facteur}
	       [] fondu(ouverture:S1 fermeture:S2 MusicF) then {Fondu S1 S2 MusicF Facteur}
	       [] fondu_enchaine(duree:S MusiC1 MusiC2) then {FonduEnchaine S MusiC1 MusiC2 Facteur}
	       [] couper(debut:S1 fin:S2 MusiC) then{Couper S1 S2 MusiC Facteur}
	       [] merge(MusicWithIntensity) then {Merge MusicWithIntensity nil Facteur}
	       [] H|T then {MixAux Interprete T Facteur Acc|{MixAux Interprete H Facteur nil}}
	       end % fin case Music
	    end % fin fun {MixAux}
	    {Browse 'debut mixAux'}
	    {MixAux Interprete Music 1.0  nil}
	 end % fin local	    
      end

      % Interprete doit interpréter une partition
      fun {Interprete Partition}
	 local Flatten NoteToEchantillon R InterpreteAux DureeTot in
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
	       local Hauteur I1 Ech in
		  case Note of note(nom:Name octave:Octave alteration:Alt) then
		     case Name 
		     of a then I1=0
		     [] b then I1=2 % 2 demitons entre a et b
		     [] c then I1=~9 %-7-2 demitons entre a et c
		     [] d then I1=~7 %-5-2 demitons entre a et d
		     [] e then I1=~5 %-4-1 demitons entre a et e
		     [] f then I1=~4 %-2-2 demitons entre a et f
		     [] g then I1=~2 %-2 demitons entre a et g
		     end % fin case Nom
		     if Alt=='#' then
			Hauteur= (Octave-4)*12 + I1 + DemiTons +1
		     else Hauteur= (Octave-4)*12 + I1 + DemiTons 
		     end
		     echantillon(hauteur:Hauteur duree:Duree instrument:none)
		  [] silence then silence(duree:Duree)
		  end%fin du case
	       end % fin local Octave Hauteur Nom I1 Ech
	    end % fin fun{NoteToEchantillon Note Duree DemiTons}

	       
	    fun {DureeTot Partition}
	       local 
		  fun{DureeTotAux Part Acc Inc}
		     case Part 
		     of nil then Acc
		     [] H|T then 
			case H
			of note(nom:Nom octave:Octave alteration:Alteration) then {DureeTotAux T Acc+Inc Inc}
			[] muet(Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
			[] duree(secondes:Seconde Partition) then {DureeTotAux T Acc+Seconde Inc}
			[] etirer(facteur:Facteur Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Facteur*Inc} Inc}
			[] bourdon(note:Note Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
			[] transpose(demitons:Entier Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
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
		  {InterpreteAux TPartition silence Duree DemiTons Acc}

	       [] etirer(facteur:F TPartition) then
		  local DureeF IsFloat in
		     {Float.is Duree IsFloat}
		     if IsFloat then {InterpreteAux TPartition Note Duree*F DemiTons Acc}
		     else {Int.toFloat Duree DureeF}
			{InterpreteAux {Flatten TPartition} Note DureeF*F DemiTons Acc} end
		  end
	       [] duree(seconde:S TPartition) then
		  local DureeTotale DureeTotF DureeIniF IsFloat in
		     DureeTotale={DureeTot {Flatten TPartition}}
		     {Float.is DureeTotale IsFloat}
		     {Int.toFloat Duree DureeIniF} %cast en float pour la division
		     if IsFloat then
			{InterpreteAux TPartition Note DureeIniF*S/DureeTotale DemiTons Acc}
		     else
			{Int.toFloat DureeTotale DureeTotF}
			{InterpreteAux TPartition Note DureeIniF*S/DureeTotF DemiTons Acc} end
						
		  end % fin local TPartitionFlat DureeTot DureeF DureeIniF

	       [] bourdon(note:NoteB TPartition) then
		  case NoteB
		  of Nom#Octave then {InterpreteAux TPartition note(nom:Nom octave:Octave alteration:'#') Duree DemiTons Acc}
		  [] Atom then
		     case {AtomToString Atom}
		     of [N]  then  {InterpreteAux TPartition note(nom:Atom octave:4 alteration:none) Duree DemiTons Acc}
		     [] [N O] then  {InterpreteAux TPartition note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:'#') Duree DemiTons Acc}
		     end
		  end
	    
	       [] transpose(demitons:DemiTons TPartition) then
		  {InterpreteAux TPartition Note Duree DemiTons Acc}

	       [] H|T then
		  {InterpreteAux T Note Duree DemiTons {InterpreteAux H Note Duree DemiTons Acc}}

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
	    {List.reverse {InterpreteAux  Partition nil 1 0 nil} R}
	    R
	    
	 end % fin local Faltten NoteToEchantillon R InterpreteAux DureeTot
      end % fin fun {Interprete Partition}
   end % fin local Audio

   local 
      Music = {Projet.load CWD#'test.dj.oz'}
   in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui démontre les fonctionalités de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validité de votre implémentation.
      {Browse {Projet.run Mix Interprete Music CWD#'Test.wav'}}
   end
end


