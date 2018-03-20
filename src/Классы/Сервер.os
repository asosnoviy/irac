Перем Сервер_Ид; // server
Перем Сервер_Имя; // name
Перем Сервер_Адрес; // agent-host
Перем Сервер_Порт; // agent-port
Перем Сервер_Параметры;

Перем Кластер_Агент;
Перем Кластер_Владелец;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера		- АгентКластера	- ссылка на родительский объект агента кластера
//   Кластер			- Кластер		- ссылка на родительский объект кластера
//   Ид					- Строка		- идентификатор сервера в кластере 1С
//
Процедура ПриСозданииОбъекта(АгентКластера, Кластер, Ид)

	Если НЕ ЗначениеЗаполнено(Ид) Тогда
		Возврат;
	КонецЕсли;

	Кластер_Агент = АгентКластера;
	Кластер_Владелец = Кластер;
	Сервер_Ид = Ид;
	
	ОбновитьДанные();

КонецПроцедуры // ПриСозданииОбъекта()

// Процедура получает данные от сервиса администрирования кластера 1С
// и сохраняет в локальных переменных
//   
Процедура ОбновитьДанные()

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("server");
	ПараметрыЗапуска.Добавить("info");

	ПараметрыЗапуска.Добавить(СтрШаблон("--server=%1", Ид()));
	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	МассивРезультатов = Служебный.РазобратьВыводКоманды(Служебный.ВыводКоманды());

	ТекОписание = МассивРезультатов[0];

	Сервер_Адрес = ТекОписание.Получить("agent-host");
	Сервер_Порт = ТекОписание.Получить("agent-port");
	Сервер_Имя = ТекОписание.Получить("name");

	ПараметрыОбъекта = ПолучитьСтруктуруПараметровОбъекта();

	Сервер_Параметры = Новый Структура();

	Для Каждого ТекЭлемент Из ПараметрыОбъекта Цикл
		ЗначениеПараметра = Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание,
																  ТекЭлемент.Значение.ИмяПоляРАК,
																  ТекЭлемент.Значение.ЗначениеПоУмолчанию); 
		Сервер_Параметры.Вставить(ТекЭлемент.Ключ, ЗначениеПараметра);
	КонецЦикла;

КонецПроцедуры // ОбновитьДанные()

// Функция возвращает идентификатор сервера 1С
//   
// Возвращаемое значение:
//	Строка - идентификатор сервера 1С
//
Функция Ид() Экспорт

	Возврат Сервер_Ид;

КонецФункции // Ид()

// Функция возвращает имя сервера 1С
//   
// Возвращаемое значение:
//	Строка - имя сервера 1С
//
Функция Имя() Экспорт

	Возврат Сервер_Имя;
	
КонецФункции // Имя()

// Функция возвращает адрес сервера 1С
//   
// Возвращаемое значение:
//	Строка - адрес сервера 1С
//
Функция Сервер() Экспорт
	
	Возврат Сервер_Адрес;
		
КонецФункции // Сервер()
	
// Функция возвращает порт сервера 1С
//   
// Возвращаемое значение:
//	Строка - порт сервера 1С
//
Функция Порт() Экспорт
	
	Возврат Сервер_Порт;
		
КонецФункции // Порт()
	
// Функция возвращает параметры сервера 1С
//   
// Возвращаемое значение:
//	Строка - параметры сервера 1С
//
Функция Параметры() Экспорт
	
	Возврат Сервер_Параметры;
		
КонецФункции // Параметры()
	
Процедура Изменить(Знач ПараметрыСервера = Неопределено) Экспорт

	Если НЕ ТипЗнч(ПараметрыСервера) = Тип("Структура") Тогда
		ПараметрыСервера = Новый Структура();
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("server");
	ПараметрыЗапуска.Добавить("update");

	ПараметрыЗапуска.Добавить(СтрШаблон("--server=%1", Ид()));
	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));

	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());
		
	ПараметрыОбъекта = ПолучитьСтруктуруПараметровОбъекта();

	Для Каждого ТекЭлемент Из ПараметрыОбъекта Цикл
		Если НЕ ПараметрыСервера.Свойство(ТекЭлемент.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыЗапуска.Добавить(СтрШаблон(ТекЭлемент.ПараметрКоманды + "=%1", ПараметрыСервера[ТекЭлемент.Ключ]));
	КонецЦикла;

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Служебный.ВыводКоманды());

	ОбновитьДанные();

КонецПроцедуры

// Функция возвращает коллекцию параметров объекта
//   
// Параметры:
//   ИмяПоляКлюча 		- Строка	- имя поля, значение которого будет использовано
//									  в качестве ключа возвращаемого соответствия
//   
// Возвращаемое значение:
//	Соответствие - коллекция параметров объекта, для получения/изменения значений
//
Функция ПолучитьСтруктуруПараметровОбъекта(ИмяПоляКлюча = "ИмяПараметра") Экспорт
	
	СтруктураПараметров = Новый Соответствие();

	ДиапазонПортов = 1561;
	КоличествоИБНаПроцесс = 8;
	КоличествоСоединенийНаПроцесс = 128;
	ПортГлавногоМенеджераКластера = 1541;

	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"ДиапазонПортов"						, "port-range"							, ДиапазонПортов);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"ЦентральныйСервер"						, "using"								, ВариантыИспользованияРабочегоСервера.Главный);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"МенеджерПодКаждыйСервис"				, "dedicate-managers"					, ВариантыРазмещенияСервисов.ВОдномМенеджере);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"КоличествоИБНаПроцесс"					, "infobases-limit"						, КоличествоИБНаПроцесс);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"МаксОбъемПамятиРабочихПроцессов"		, "memory-limit"						, 0);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"КоличествоСоединенийНаПроцесс"			, "connections-limit"					, КоличествоСоединенийНаПроцесс);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"БезопасныйОбъемПамятиРабочихПроцессов"	, "safe-working-processes-memory-limit"	, 0);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"БезопасныйРасходПамятиЗаОдинВызов"		, "safe-call-memory-limit"				, 0);
	Служебный.ДобавитьПараметрОписанияОбъекта(СтруктураПараметров, ИмяПоляКлюча,
			"ПортГлавногоМенеджераКластера"			, "cluster-port"						, ПортГлавногоМенеджераКластера);

	Возврат СтруктураПараметров;

КонецФункции // ПолучитьСтруктуруПараметровОбъекта()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
