% Vous ne pouvez pas utiliser le mot-clé 'declare'.
local Mix Interprete Projet CWD in

   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
   % CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}%Zélie
   CWD = {Property.condGet 'testcwd' '/media/damien/Home/Damien/Documents/UCL/FSA12-BA/Projet_Informatique_2/'}%DAMIEN

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
	 local MixAux ListEchantillonToAudio EchantillonToAudio Add Frequence Clip RepetitionNfois RepetitionDuree Echo Merge Fondu Pi=3.1415 in

	    fun{Add List1 List2}
	       local AddAux S1 S2 in
		  S1={Length List1}
		  S2={Length List2}
		  fun{AddAux L1 L2 Acc}
		     case L1
		     of nil then Acc
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

	    
	    fun{Frequence Hauteur}
	       local R HtoFloat in
		  {Int.toFloat Hauteur HtoFloat}
		  {Number.pow 2.0 (HtoFloat/12.0) R}
		  R*440.0
	       end %fin du local
	    end%fin de la fonction frequence

	    fun{EchantillonToAudio Echantillon Facteur Acc}
	       local F EchToAudio in
		  fun{EchToAudio Ech Fac I Vec}
		     local IsFloat DureeF Sin in
			case Ech
			of silence(duree:S) then
			   {Float.is S IsFloat}
			   if IsFloat then DureeF=S
			   else {Int.toFloat S DureeF} end
			   if I>=DureeF*44100.0 then Vec
			   else {EchToAudio Ech Fac I+1.0 0.0|Vec} end
			[] echantillon(hauteur:Hauteur duree:S instrument:Instrument) then
			   F={Frequence Echantillon.hauteur}
			   {Float.is S IsFloat}
			   if IsFloat then DureeF=S
			   else {Int.toFloat S DureeF} end
			   {Float.sin (2.0*Pi*I*F)/44100.0 Sin}
			   if I>=DureeF*44100.0 then Vec
			   else {EchToAudio Ech Fac I+1.0 (Fac*1.0*Sin)|Vec} end
			end
		     end % fin local
		  end % fin EchToAudio
		  {EchToAudio Echantillon Facteur 0.0 Acc}
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
	       local DureeTot VecAudio FonduAux in
		  VecAudio={MixAux Interprete Music Facteur nil}
		  DureeTot= {IntToFloat{Length VecAudio}}
		  {Browse {IsFloat DureeTot}}
		  fun{FonduAux T VA Acc}
		     local Douv=Ouverture*44100.0 Dferm=Fermeture*44100.0 Dt={IntToFloat T} in
			case VA
			of nil then {Reverse Acc}
			[] H|Q andthen Dt<Douv then {FonduAux T+1 Q ((H*Dt)/Douv)|Acc}
			[] H|Q andthen Dt>=Dferm then {FonduAux T+1 Q ((DureeTot-Dt)*H/Dferm)|Acc}
			[] H|Q then {FonduAux T+1 Q H|Acc}
			end % fin case
		     end % fin local
		  end % fin FonduAux
		  {FonduAux 0 VecAudio nil}
	       end % fin local
	    end % fin Fondu
	    
	       
	    
	    
	    fun{MixAux Interprete  Music Facteur  Acc}
	       case Music
	       of nil then {Flatten Acc}
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
			%[] fondu_enchaine(duree:S Music1 Music2) then
			%[] couper(debut:S1 fin:S2 Music) then
	       [] merge(MusicWithIntensity) then {Merge MusicWithIntensity nil Facteur}
	       [] H|T then {MixAux Interprete T Facteur Acc|{MixAux Interprete H Facteur nil}}
	       end % fin case Music
	    end % fin fun {MixAux}
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
      Music = {Projet.load CWD#'example.dj.oz'}
   in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui démontre les fonctionalités de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validité de votre implémentation.
      {Browse {Projet.run Mix Interprete Music CWD#'outTest.wav'}}
   end
end


