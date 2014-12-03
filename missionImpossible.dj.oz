local
%Silence=[voix([silence(duree:1.0)])]
T1=[g3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 [g3]) a#3 c4 g3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 [g3])]
T2=[etirer(facteur:2.0 [silence]) etirer(facteur:0.5 [a#4]) etirer(facteur:0.5 [g4])]

Int=[etirer(facteur:2.0 [silence]) etirer(facteur:0.5 [a#4]) etirer(facteur:0.5 [c4]) etirer(facteur:4.0 [silence])]
T3= [a#3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 [a#3])]
T4=[etirer(facteur:0.5 [a#4]) etirer(facteur:0.5 [a#4]) etirer(facteur:2.0 [f#5])]


Debut=[T1 [f3 f#3] T1 T2 [etirer(facteur:2.0 [d4])] T2 [etirer(facteur:2.0 [c#4])] T2 [etirer(facteur:2.0 [c4])] Int]
Fin=[f4 f#4 g4 T4 etirer(facteur:2.0 [silence]) T4]

%Partition1=[T1 [f3 f#3] T1 T2 [etirer(facteur:2.0 [d5])] T2 [etirer(facteur:2.0 [c#5])] T2 [etirer(facteur:2.0 [c5])] Int T3 a#4 c5 T3 f4 f#4 g4 T4 etirer(facteur:2.0 [silence]) T4]
%Doigt2=[d4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 [d4])]
%Doigt3=[g4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 [g4])]
Partition1=[Debut T3 [a#4 c5] T3 Fin]
MainGauche1=[partition(Partition1)]
%MainGauche2=[partition([Debut Doigt2 [a#4 c4] Doigt2 Fin])]
%MainGauche3=[partition([Debut Doigt3 [a#4 c4] Doigt3 Fin])]
%MainGauche=[merge([0.33#MainGauche1 0.33#MainGauche2 0.33#MainGauche3])]


Tune1=[g2 duree(secondes:0.5 [silence]) duree(secondes:1.5 [g2]) a#2 c3]
Tune2=[g2 duree(secondes:0.5 [silence]) duree(secondes:1.5 [g2]) f2 f#2]
Partition2=[Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2]
MainDroite=[partition(Partition2)]


%Music1=[partition(Partition1)]

%Music2=[partition([etirer(facteur:40.0 [silence]) d4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 d4)])]
%Music3=[partition([etirer(facteur:40.0 [silence]) g4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g4)])]


in
[[merge([0.5#MainGauche1 0.5#MainDroite])]]
end
