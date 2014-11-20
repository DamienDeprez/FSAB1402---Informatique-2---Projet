% Fichier joie.dj.oz

% Hymne à la joie :-)
local
   Tune = [b b c d d c b a g g a b]
   End1 = [accelere(facteur:1.5 b) accelere(facteur:0.5 a) accelere(facteur:2.0 a)]
   End2 = [accelere(facteur:1.5 a) accelere(facteur:0.5 g) accelere(facteur:2.0 g)]
   Interlude = [a a b g a accelere(facteur:0.5 [b c#5])
                    b g a accelere(facteur:0.5 [b c#5])
                b a g a accelere(facteur:2.0 d) ]
in
   [Tune End1 Tune End2 Interlude Tune End2]
end

