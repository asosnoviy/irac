Перем мИд; //cluster
Перем мИмя; //name
Перем мСервер; //host
Перем мПорт; //port
Перем мПараметры;

Перем мАгент;
Перем мАдминистратор;
Перем мАдминистраторы;
Перем мСерверы;
Перем мМенеджеры;
Перем мСеансы;
Перем мСоединения;
Перем мИнформационныеБазы;
Перем мПрофилиБезопастности;

Перем Лог;

Процедура ПриСозданииОбъекта(АгентКластера, Ид, Администратор = "", ПарольАдминистратора = "")

	Если НЕ ЗначениеЗаполнено(Ид) Тогда
		Возврат;
	КонецЕсли;

	мАгент = АгентКластера;
	мИд = Ид;
	
	Если ЗначениеЗаполнено(Администратор) Тогда
		мАдминистратор = Новый Структура("Администратор, Пароль", Администратор, ПарольАдминистратора)
	Иначе
		мАдминистратор = Неопределено;
	КонецЕсли;

	мАдминистраторы = Администраторы(Истина);

	ОбновитьДанные();

КонецПроцедуры

Процедура ОбновитьДанные()

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(мАгент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("cluster");
	ПараметрыЗапуска.Добавить("info");

	//ПараметрыЗапуска.Добавить(Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", мИд));

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	МассивРезультатов = Служебный.РазобратьВыводКоманды(Служебный.ВыводКоманды());

	ТекОписание = МассивРезультатов[0];

	мСервер = ТекОписание.Получить("host");
	мПорт = ТекОписание.Получить("port");
	мИмя = ТекОписание.Получить("name");

	мПараметры =
		Новый Структура("ИнтервалПерезапуска,
						|ДопустимыйОбъемПамяти,
						|ИнтервалПревышенияДопустимогоОбъемаПамяти,
						|ДопустимоеОтклонениеКоличестваОшибокСервера,
						|ПринудительноЗавершатьПроблемныеПроцессы,
						|ВыключенныеПроцессыОстанавливатьЧерез,
						|ЗащищенноеСоединение,
						|УровеньОтказоустойчивости,
						|РежимРаспределенияНагрузки",
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "lifetime-limit", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "max-memory-size", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "max-memory-time-limit", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "errors-count-threshold", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "kill-problem-processes", ДаНет.Нет),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "expiration-timeout", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "security-level", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "session-fault-tolerance-level", 0),
						Служебный.ПолучитьЗначениеИзСтруктуры(ТекОписание, "load-balancing-mode", РежимыРаспределенияНагрузки.ПоПроизводительности));

КонецПроцедуры

Функция СтрокаАвторизации() Экспорт
	
	Если НЕ ТипЗнч(мАдминистратор)  = Тип("Структура") Тогда
		Возврат "";
	КонецЕсли;

	Если НЕ мАдминистратор.Свойство("Администратор") Тогда
		Возврат "";
	КонецЕсли;

	Лог.Отладка("Администратор " + мАдминистратор.Администратор);
	Лог.Отладка("Пароль <***>");

	СтрокаАвторизации = "";
	Если Не ПустаяСтрока(мАдминистратор.Администратор) Тогда
		СтрокаАвторизации = СтрШаблон("--cluster-user=%1 --cluster-pwd=%2", мАдминистратор.Администратор, мАдминистратор.Пароль);
	КонецЕсли;
			
	Возврат СтрокаАвторизации;
	
КонецФункции
	
Процедура УстановитьАдминистратора(Администратор, Пароль) Экспорт
	
	мАдминистратор = Новый Структура("Администратор, Пароль", Администратор, Пароль);
	
КонецПроцедуры
	
Функция Ид() Экспорт

	Возврат мИд;

КонецФункции

Функция Имя() Экспорт

	Возврат мИмя;
	
КонецФункции

Функция Сервер() Экспорт
	
		Возврат мСервер;
		
КонецФункции
	
Функция Порт() Экспорт
	
		Возврат мПорт;
		
КонецФункции
	
Функция Параметры() Экспорт
	
		Возврат мПараметры;
		
КонецФункции
	
Функция Администраторы(ОбновитьДанные = Ложь) Экспорт

	Если ОбновитьДанные Тогда
		мАдминистраторы = Новый АдминистраторыКластера(мАгент, ЭтотОбъект);
	КонецЕсли;

	Возврат мАдминистраторы;

КонецФункции

Функция Серверы(ОбновитьДанные = Ложь) Экспорт
	
	Если ОбновитьДанные Тогда
		мСерверы = Новый СерверыКластера(мАгент, ЭтотОбъект);
	КонецЕсли;
	
	Возврат мСерверы;
	
КонецФункции
	
Функция Менеджеры(ОбновитьДанные = Ложь) Экспорт
	
	Если ОбновитьДанные Тогда
		мМенеджеры = Новый МенеджерыКластера(мАгент, ЭтотОбъект);
	КонецЕсли;
	
	Возврат мМенеджеры;
	
КонецФункции
	
Функция Администратор() Экспорт
	Возврат мАдминистратор;
КонецФункции

Процедура Изменить(Знач Имя = "", Знач ПараметрыКластера = Неопределено) Экспорт

	Если НЕ ТипЗнч(ПараметрыКластера) = Тип("Структура") Тогда
		ПараметрыКластера = Новый Структура();
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(мАгент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("cluster");
	ПараметрыЗапуска.Добавить("update");

	ПараметрыЗапуска.Добавить(мАгент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", мИд));

	Если ЗначениеЗаполнено(Имя) Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));
	КонецЕсли;
	
	Если ПараметрыКластера.Свойство("ИнтервалПерезапуска") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--lifetime-limit=%1", ПараметрыКластера.ИнтервалПерезапуска));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ДопустимыйОбъемПамяти") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--max-memory-size=%1", ПараметрыКластера.ДопустимыйОбъемПамяти));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ИнтервалПревышенияДопустимогоОбъемаПамяти") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--max-memory-time-limit=%1", ПараметрыКластера.ИнтервалПревышенияДопустимогоОбъемаПамяти));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ДопустимоеОтклонениеКоличестваОшибокСервера") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--errors-count-threshold=%1", ПараметрыКластера.ДопустимоеОтклонениеКоличестваОшибокСервера));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ПринудительноЗавершатьПроблемныеПроцессы") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--kill-problem-processes=%1", ПараметрыКластера.ПринудительноЗавершатьПроблемныеПроцессы));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ВыключенныеПроцессыОстанавливатьЧерез") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--expiration-timeout=%1", ПараметрыКластера.ВыключенныеПроцессыОстанавливатьЧерез));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("ЗащищенноеСоединение") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--security-level=%1", ПараметрыКластера.ЗащищенноеСоединение));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("УровеньОтказоустойчивости") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--session-fault-tolerance-level=%1", ПараметрыКластера.УровеньОтказоустойчивости));
	КонецЕсли;
	Если ПараметрыКластера.Свойство("РежимРаспределенияНагрузки") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--load-balancing-mode=%1", ПараметрыКластера.РежимРаспределенияНагрузки));
	КонецЕсли;

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Служебный.ВыводКоманды());

	ОбновитьДанные();

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
