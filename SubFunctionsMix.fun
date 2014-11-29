local Frequence EchantillonToVecteurAudio Clip RepetitionDuree RepetitionNfois MultiplyList in
	fun{MultiplyList N L} %Equivalent à {List.map +Xs +P ?Ys} ou on applique P à tous les éléments de Xs
		local MultiplyAux in
			fun{MultiplyAux L1 Acc}
				case L1 
				of nil then Acc
				[] H|T then {MultiplyAux T (H*N)|Acc }
				end
			end
		{MultiplyAux {Reverse L} nil}
   end
end
	
	fun{Frequence Hauteur}
		R HtoFloat in
		{Int.toFloat Hauteur HtoFloat}
		{Number.pow 2.0 (HtoFloat/12.0) R}
		R*440.0
		end %fin du local
	end%fin de la fonction frequence
	
	fun{EchantillonToVecteurAudio Echantillon}
		local EchantillonToVecAux F in
			F={Frequence Echantillon.hauteur} %Frequence en fonction de la hauteur de l'echantillon
			fun{EchantillonToVecAux Echantillon Inc Vec} %Vec = vecteur Audio a renvoyé, Inc= increment
				local Frac Sin Ai B in
				{Value.'>' Inc (Echantillon.duree)*44100.0 B}
				Frac=(2.0*PI*F*Inc)/44100.0
				 {Float.sin Frac Sin}
				 {Number.'*' 0.5 Sin Ai} 
				if B then Vec %Si on depasse la valeur d'echantillonage, notre Vecteur est complet
				else 
					{EchantillonToVecAux Echantillon Inc+1.0 Ai|Vec}%On garde le meme echantillon
				end%fin du %if
				end%fin du local pour Frac Sin Ai et B
			end%fin de la fonction EchantillonToVecAux
		{EchantillonToVecAux Echantillon 0.0 nil}
		end%fin du local pour F et EchantillonToVecAux
	end%fin fonction EchantillonToVecteurAudio

	fun{Clip Up Down VecteurAudio}
		local R
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
		{List.reverse {ClipAux VecteurAudio nil} R}
		R
		end%fin du local ClipAux
	end%Fin de la fonction Clip
	
	fun{RepetitionNfois N Music}
		local
			fun{RepetitionAux N Acc}
				if N==0 then Acc
				else {RepetitionAux N-1 {Mix Interprete Music}|Acc}
			end
		in
		{RepetitionAux N nil}
		end
	end
	
	fun{RepetitionDuree Duree Musique}
	SizeVec= Duree*44100.0
	L={Mix Interprete Musique}
		local RepetitionAux in
			fun{RepetitionAux L1 Size Acc}
				case L1 of nil then Acc
				[] H|T {RepetitionAux T Size-1 H|Acc}
			end
		end
	end
	
	fun{Echo Delai Music}
		local MusicWithDelai in
			MusicWithDelai=silence(duree:Delai)|Music
			{Merge [0.5#Music 0.5#MusicWithDelai]}
		end
	end
	
	fun{EchoDecadence Delai Decadence Music}
		local MusicWithDelai IntensiteEcho IntensiteMusic in %Decadence =Iecho/Imusic et Iecho+Imusic=1 --> Imusic=1/(decadence+1)
			MusicWithDelai=silence(duree:Delai)|Music
			IntensiteMusic=1.0/(Decadence+1.0)
			IntensiteEcho=IntensiteMusic*Decadence
			{Merge [(IntensiteMusic#Music IntensiteEcho#MusicWithDelai]}
		end
	end
	fun{Merge L}
	
	end
	
end%fin du local des subfonctions


declare
PI=3.14159265359
fun{Mix Interprete Music}
	local R fun{MixAux Interprete Music Acc}%Acc pour stocker l'ensemble des vecteurs audio de chaque echantillon
		case Music of nil then Acc
		[] H|T then case H
			of partition(P) then {Mix Interprete voix({Interprete P})}
			[] voix(H1|T1) then {MixAux Interprete T {MixAux Inteprete T1 {EchantillonToVecteurAudio H1}|Acc}}
			[] wave(filename) then {MixAux Interprete T {Projet.readFile filename}|Acc}
			%[] merge(musiqueIntensifiee)
			[] renverser(musique) %then {List.reverse renverser.1 R} andthen {MixAux Interprete T {Mix Interprete R}|Acc}
			[] repetition(nombre:nat musique) then {MixAux Interprete T {RepetitionNfois repetition.nombre repetition.1}|Acc}
			%[] repetition(duree:sec musique) then {MixAux Interprete T {RepetitionDuree repetition.duree}|Acc}
			[] clip(bas:float haut:float musique) then {Clip clip.haut clip.bas {Mix Inteprete clip.1}}
			[] echo(delai:sec musique) then {MixAux Inteprete T {Echo echo.delai echo.1}|Acc}
			[] echo(delai:sec decadence:float musique) then {MixAux Inteprete T {EchoDecadence echo.delai echo.decadence echo.1}|Acc}
			%[] echo(delai:sec decadence:float repetition:entier musique)
			%[] fondu(ouverture:sec fermeture:sec musique)
			%[] fondu_enchaine(duree:sec musique1 musique2)
			end%fin du case H

		end %fin du case Music
		{Flatten Acc}
	in
	{MixAux Interprete Music nil}
	end%fin du local

end