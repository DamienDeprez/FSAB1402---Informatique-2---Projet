% Vous ne pouvez pas utiliser le mot-cle 'declare'.
local Mix Interprete Projet CWD in
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
   CWD = {Property.condGet 'testcwd' 'D:/Bac2/Q3/Informatique/Projet2014/'}
%  CWD = {Property.condGet 'testcwd' 'D:................................/'}DAMIEN
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
		local fun {InterpreteAux Partition Acc}
			case Partition
			of nil then Acc 
			[] Nom#Octave then 
			{InterpreteAux note(nom:Nom octave:Octave alteration:'#') Acc}
			[] Atom then 
				case {AtomToString Atom} 
				of [N] then {InterpreteAux note(nom:Atom octave:4 alteration:none}
				[] [N O] then {InterpreteAux note(nom:{StringToAtome [N]} octave:{StringToInt [O]} alteration:none}
				end
			[] note(nom:Nom octave:Octave alteration:Alteration) then I1 Ech in
				case Nom 
				of a then I1=0
				[] b then I1=1
				[] c then I1=2
				[] d then I1=3
				[] e then I1=4
				[] f then I1=5
				[] g then I1=6
				end
				Ech = echantillon(hauteur:(6*(4-Octave)+2*I1) duree:1 instrument:none)
			{InterpreteAux nil Ech|Acc}				
			[] H|T then %rappeler la fonction sur H ET sur T, car peuvent tous les deux etre une liste
		end
		in
		{InterpreteAux Partition nil}
		end
		
      end
	
   end

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
