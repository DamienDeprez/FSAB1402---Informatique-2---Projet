local Frequence EchantillonToVecteurAudio in
	fun{Frequence Hauteur}
		R H HtoInt in
		{Int.toFloat Hauteur HtoInt}
		{Float.'/' HtoInt 12.0 H}
		{Number.pow 2.0 H	R}
		R*440.0
		end %fin du local
	end%fin de la fonction frequence
	
	fun{EchantillonToVecteurAudio Echantillon}
		local EchantillonToVecAux F Sin Frac Ai in
			F={Frequence Echantillon.hauteur} %Frequence en fonction de la hauteur de l'echantillon
			fun{EchantillonToVecAux Echantillon Inc Vec} %Vec = vecteur Audio a renvoyé, Inc= increment
				{Float.'/' (2*PI*F*Inc) 44100.0 Frac} %COmment Calculer pi? 
				{Float.sin Frac Sin}
				Ai= 0.5*Sin %Element courant de la suite de valeurs du vecteur audio
				if Inc>(Echantillon.duree)*44100 then Vec %Si on depasse la valeur d'echantillonage, notre Vecteur est complet
				else {EchantillonToVecAux Echantillon Inc+1 Ai|Vec}%On garde le meme echantillon
				end%fin du %if
			end%fin de la fonction EchantillonToVecAux
		{EchantillonToVecAux Echantillon 0 nil}
		end%fin du local
	end%fin fonction EchantillonToVecteurAudio

	
	
end

fun{Mix Interprete Music}
	local fun{MixAux Interprete Music Acc}
		case Music
		of partition(P) then {Mix Interprete voix({Interprete P})}
		[] voix(H|T) then {MixAux Interprete Music {}}
		
		end %fin du case Music
		
	in
	{MixAux Interprete Music nil}
	end%fin du local

end