--[[
%% autostart
%% properties
%% events
%% globals
--]]

if fibaro:countScenes() > 1 then fibaro:abort() end -- zabij instancję sceny gdy odpalone są jednocześnie więcej niż 1 instancja sceny.

-- ************ BEGIN configuration block ************
TIME_BETWEEN_LOOPS = 30 -- Czas co jaki zostanie uruchomiony kod w pętli (w minutach)
TIME_ON_VACATION_TEMP = 10
HEATING_ZONES = {"Kuchnia", "Wiatrołap" }
VACATION_TEMPERATURE = 30 -- temperatura jaką chcemy ustawić jako wakacyjna
-- ************ END configuration block ************

-- ************ BEGIN classes block ************
---- 9. Poniżej masz deklarację czegoś w rodzaju klasy w Lua. Jeżeli nie wiesz czym są klasy to poczytaj o programowaniu zoreintowanym obiektowo.
-- To trochę tak jak z piernikami na święta.
-- FOREMKA jest klasą
-- PIERNIK jest obiektem klasy FOREMKA
-- z FOREMEK wychodzą PIERNIKI
-- z poniższej klasy HeatingZone wychodzą obiekty HeatingZone
-- Ludzie myślą obiektowo, które posiadają jakieś właściowości i mogą coś robić (rower ma 2 koła, można na nim jechać)
-- Fibaro przez swoje API zwraca bardzo podobny obiekt strefy ogrzewania zakodowany w JSONie.
-- Cała ta klasa to tylko nakładka, która pozwala napisać kod w bardziej czytelny sposób
HeatingZone = {}
function HeatingZone:new(zoneName) -- 10 przy tworzeniu obiektu klasy HeatingZone, musimy do niego przekazać nazwę tej strefy ogrzewania (tak jak ją nazwałeś w Panelu Ogrzewania)

	local this = {} -- 11. Do this zapisujemy właściwości obiektu czyli coś co go charakteryzuje np. kolor piernika, kształt itd...
	this.fibaroZoneObject = (function() -- 12. Chcemy dostać obiekt strefy ogrzewania z API Fibaro i zapisać go w naszej klasie, żebyśmy mogli w nim coś później zmodyfikować
		local allHeatingZones = api.get("/panels/heating") -- 13. to właśnie zwraca listę stref ogrzewania w Fibaro
		for _, heatingZone in pairs(allHeatingZones) do -- 14. iterujemy po strefach ogrzewania z Fibaro. Do heatingZone zapisze nam się cały obiekt strefy ogrzewania, który posiada masę parametrów
			if heatingZone.name == zoneName then -- 15. sprawdzamy która strefa nazywa się tak samo jak ta która nas aktualnie interesuje. Parametr name z heatingZone odczytujemy właśnie w taki sposób heatingZone.name
				return heatingZone -- 16. Jeśli to ta której szukamy to zwracamy cały obiekt w konsekwencji zostanie on zapisany do właściwości fibaroZoneObject w instancji tworzonego obiektu (this) -> this.fibaroZoneObject
			end
		end
	end)()

	function this:setVacationTemperature(temperature) -- 18. Tutaj masz przykład metody (czyli co obiekt może zrobić) do ustawiania temperatury wakacyjnej
		self.fibaroZoneObject.properties.vacationTemperature = temperature -- 19. w Fibarowskim obiekcie zmieniamy wartość parametru vacationTemperature
		api.put("/panels/heating/"..self.fibaroZoneObject.id, self.fibaroZoneObject) -- 20. Zapisujemy go w Fibaro z wykorzystaniem API
	end

	function this:backToSchedule() -- 24. Temperaturę wakacyjną wyłącza się poprzez przypisanie jej temperatury 0.
		self:setVacationTemperature(0)
	end

	return this
end
-- ************ END classes block ************

-- ************ BEGIN creating objects block ************
-- 5. Tutaj zapisujemy strefy ogrzewania do zmiennej heatingZones
heatingZones = (function()
    local heatingZones = {} -- 6. Tworzymy pustą tablicę (zmienna która przechowuje wiele elementów np. {"Wojtek", "Ania", "Kuba"}. To nie muszą być pojedyczńccze wartości tylko skomplikowane, rozbudowane elementy. )
    for _, heatingZoneName in pairs(HEATING_ZONES) do -- 7. Iterujemy po nazwach stref ogrzewania, które deklarujemy na samej górze np. "Kuchnia", "Wiatrołap"... do heatingZoneName będzie zapisywało się kolejno właśnie "Kuchnia", "Wiatrołap". Mega przydatny rodzaj pętli.
        table.insert(heatingZones, HeatingZone:new(heatingZoneName)) -- 8. dodajemy po kolei do tablicy heatingZones obiekty, które utworzy nam klasa HeatingZone przez wywołanie metody new (tzw. konstruktor).
    end
end)()
-- ************ END creating objects block ************

-- ************ BEGIN helper functions ************
function loop()
    -- 2. Wszystko w funkcji loop będzie wykonywane w pętli (nazwa loop nie ma tutaj nic do rzeczy)
    if ((math.floor(os.time()/60) - math.floor(1579820400/60)) % TIME_BETWEEN_LOOPS == 0) then -- 3. Tutaj jest warunek, który sprawdza czy minęło TIME_BETWEEN_LOOPS (zadeklarowane na samej górze - 30) minut (nie do końca chodzi o przemijanie czasu, ale nie ma sensu tego analizować)
        for _, heatingZone in pairs(heatingZones) do -- 4. Iteracja po obiektach HeatingZone, skocz do punktu 5, żeby zobaczyć skąd się biorą te obiekty i czym w ogóle są
            heatingZone:setVacationTemperature(VACATION_TEMPERATURE) -- 17. Wywołanie metody do ustawiania temperatury wakacyjnej
        end
        fibaro:sleep(1000 * 60 * TIME_ON_VACATION_TEMP) -- 21. Uśpienie sceny na zadany czas. Parametr podaje się w milisekundach więc żeby uśpić na 10 minut trzeba trochę matematyki. 1000 milisekund (sekunda) * 60 -> 1 minuta -> * TIME_ON_VACATION_TEMP (zadeklarowane na samej górze - 10) daje nam 10 minut.
        for _, heatingZone in pairs(heatingZones) do -- 22. Iteracja po obiektach HeatingZone, tak samo jak wyżej
            heatingZone:backToSchedule() -- 23. wywołanie metody na obiekcie, który zresetuje nastawę do tej z harmonogramu
        end
    end

    setTimeout(loop, 1000 * 60) -- 24. Poczekaj 1000 milisekund * 60 -> minutę i odpal funkcję loop. Jak widzisz funkcja odpala się co minutę, ale ten długi, skomplikowany warunek z punktu 3 nie wpuszcza jej dalej (dopóki nie minie 30 minut)
end
-- ************ END helper functions ************

-- ************ BEGIN code block ************
fibaro:debug("START")

loop() -- 1. Tutaj zaczynamy i tutaj jest wywołanie funkcji loop zadeklarowanej powyżej

fibaro:debug("END")
-- ************ END code block ************
