Перем мАгент;
Перем мКластер;
Перем мЭлементы;
Перем Лог;

Процедура ПриСозданииОбъекта(АгентКластера, Кластер)

	мАгент = АгентКластера;
	мКластер = Кластер;

	ОбновитьДанные();

КонецПроцедуры

Функция ОбновитьДанные()
	
	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(мАгент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("manager");
	ПараметрыЗапуска.Добавить("list");

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", мКластер.Ид()));
	ПараметрыЗапуска.Добавить(мКластер.СтрокаАвторизации());

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	МассивРезультатов = Служебный.РазобратьВыводКоманды(Служебный.ВыводКоманды());

	мЭлементы = Новый Соответствие();
	Для Каждого ТекОписание Из МассивРезультатов Цикл
		мЭлементы.Вставить(ТекОписание["name"], ТекОписание);
	КонецЦикла;

КонецФункции

Функция ПолучитьСписок(ОбновитьДанные = Ложь) Экспорт

	Если ОбновитьДанные Тогда
		ОбновитьДанные();
	КонецЕсли;

	Возврат мЭлементы;

КонецФункции

Функция Получить(Имя, ОбновитьДанные = Ложь) Экспорт

	Если ОбновитьДанные Тогда
		ОбновитьДанные();
	КонецЕсли;

	Возврат мЭлементы[Имя];

КонецФункции

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
