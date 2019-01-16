#Использовать json
#Использовать cmdline
// #Использовать asserts
// #Использовать strings
#Использовать 1commands
#Использовать tempfiles

Перем ПутьК1С;
Перем ПроектКлюч;
Перем ПроектФайл;
Перем ПроектИмя;
Перем База1С;
Перем ПользовательИмя;
Перем ПользовательПароль;
Перем КаталогРелизов;
Перем КаталогДампа;


// Процедура ЧтениеПараметров(МенеджерПараметров, ИмяПроекта)
//     МенеджерПараметров.УстановитьФайлПараметров("Настройки.json");
//     МенеджерПараметров.Прочитать();

//   	oscript_dir  = МенеджерПараметров.Параметр("oscript_dir");
// 	КаталогПроекта = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Проект");
// 	КаталогРелизов = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Релиз");
// 	КаталогДампа  = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Исходники");
// КонецПроцедуры


// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - IN - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - IN - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
Функция СтрокаСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	Возврат Результат;
КонецФункции


Процедура PrintLine(char="-", length=60)
	// СтрФунк = Новый СтроковыеФункции;
	// СтрокаСимволов = СтрФунк.СформироватьСтрокуСимволов(char, length);
	// СтрокаСимволов = СтрокаСимволов(char, length);
	Сообщить(СтрокаСимволов(char, length));
КонецПроцедуры


Функция ВзятьВКавычки(Строка)
	Возврат """" + Строка + """";
КонецФункции


Функция ПолучитьТекстФайла(ФайлИмя)
	Перем оФайл, оТекст, ТекстФайла;

	ТекстФайла = "";
	оФайл = Новый Файл(ФайлИмя);
	Если оФайл.Существует() Тогда
		оТекст = Новый ЧтениеТекста(ФайлИмя, КодировкаТекста.UTF8);
		ТекстФайла = оТекст.Прочитать();
		оТекст.Закрыть();
		ОсвободитьОбъект(оТекст);
	КонецЕсли;
	Возврат ТекстФайла;
КонецФункции


Функция ТекстФайлаЗаписать(ФайлИмя, ТекстФайла)
	Перем оФайл, оТекст;
	Перем Результат;

	оФайл = Новый Файл(ФайлИмя);
	оТекст = Новый ЗаписьТекста(ФайлИмя, КодировкаТекста.UTF8);
	оТекст.Записать(ТекстФайла);
	оТекст.Закрыть();
	ОсвободитьОбъект(оТекст);
	Возврат Результат;
КонецФункции


Процедура ОбработкуРазобрать(ПутьКФайлу, КаталогДампа)

	Команда = Новый Команда;
	СтрокаЗапуска = ВзятьВКавычки(ПутьК1С) + " DESIGNER"
		+ " /F" + ВзятьВКавычки(База1С)
		+ " /N" + ВзятьВКавычки(ПользовательИмя)
		+ " /P" + ВзятьВКавычки(ПользовательПароль)
		+ " /DumpExternalDataProcessorOrReportToFiles" + КаталогДампа
		+ " " + ПутьКФайлу;
		// + " /Out" + ОбъединитьПути(КаталогВременныхФайлов(), ПроектИмя + "_dump.log");
	Команда.УстановитьСтрокуЗапуска(СтрокаЗапуска);
	КодВозврата = Команда.Исполнить();
	// Сообщить(КодВозврата);
	// Сообщить(Команда.ПолучитьВывод());
КонецПроцедуры


Процедура ПодготовитьИсходники(Каталог)
	Файлы = НайтиФайлы(Каталог, "*.bsl", Истина);
	Для Каждого НайденныйФайл Из Файлы Цикл
		Если НайденныйФайл.ЭтоФайл() Тогда
			ОбработатьФайл(НайденныйФайл.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Функция ПолучитьИмяПроекта(КаталогДампа)
	Файлы = НайтиФайлы(КаталогДампа, "*.*", Ложь);
	Для Каждого оФайл Из Файлы Цикл
		Если оФайл.ЭтоКаталог() Тогда
			Возврат оФайл.Имя;
		КонецЕсли;
	КонецЦикла;
КонецФункции


Функция ПолучитьДанныеВерсии(ИмяФайла, РелизНомер)
	Перем PATTERN;
	Перем Результат;

	PATTERN = "\n\s*м_сОбработка_Версия\s*=\s*\""(\d{1,2}-\d{2}-\d{3})""\s*;";
	// PATTERN_DATE = "\n\s*м_сОбработка_Дата\s*=\s*\""(\d{2}.\d{2}.\d{4})\""\s*;";

	ТекстФайла = ПолучитьТекстФайла(ИмяФайла);

	Результат = Новый РегулярноеВыражение(PATTERN).НайтиСовпадения(ТекстФайла);
	Если Результат.Количество() = 0 Тогда
		Сообщить("При поиске номера версии совпадений не найдено!")
	ИначеЕсли Результат.Количество() > 1 Тогда
		Сообщить("При поиске номера версии найдено более одного совпадения!")
	Иначе
		РелизНомер = Результат[0].Группы[1].Значение;
	КонецЕсли;

КонецФункции


Функция ПолучитьПутьМастерСборки()
	Перем ВерсияНомер;
	Перем ИмяФайлаСборки;

	ФайлДляПоиска = ОбъединитьПути(КаталогДампа, ПроектИмя, "Ext\ObjectModule.bsl");
	ПолучитьДанныеВерсии(ФайлДляПоиска, ВерсияНомер);
	Сообщить("Номер версии = " + ВерсияНомер);
	ИмяФайлаСборки = ОбъединитьПути(
		КаталогРелизов,
		ПроектИмя + "_" + ВерсияНомер + ".epf"
		);
	Возврат ИмяФайлаСборки;
КонецФункции


Процедура ОбработатьФайл(ИмяФайла)
	Перем PATTERN;
	PATTERN = "( */{2,}.*$)|(^ *#Область .*\n+)|(^ *#КонецОбласти *$\n+)|(\s+$)";

	ТекстФайла = ПолучитьТекстФайла(ИмяФайла);

	Результат = Новый РегулярноеВыражение(PATTERN).Заменить(ТекстФайла, "");
	Результат = Новый РегулярноеВыражение("\n{3,}").Заменить(Результат, Символы.ПС + Символы.ПС);
	ТекстФайлаЗаписать(ИмяФайла, Результат);
	Сообщить("..." + СтрЗаменить(ИмяФайла, КаталогДампа, ""));
КонецПроцедуры


Процедура ОбработкуСобрать(ПутьКФайлуСборкиПроекта, ПутьКФайлуМастерОбработки)
	Перем ПутьКФайлуЛога;

	ПутьКФайлуЛога = ОбъединитьПути(КаталогВременныхФайлов(), ПроектИмя + "_load.log");
	Команда = Новый Команда;
	СтрокаЗапуска = ВзятьВКавычки(ПутьК1С) + " DESIGNER"
		+ " /F" + ВзятьВКавычки(База1С)
		+ " /N" + ВзятьВКавычки(ПользовательИмя)
		+ " /P" + ВзятьВКавычки(ПользовательПароль)
		+ " /LoadExternalDataProcessorOrReportFromFiles " + ПутьКФайлуСборкиПроекта
		+ " " + ПутьКФайлуМастерОбработки
		+ " /Out" + ПутьКФайлуЛога;

	Сообщить("Формирование мастер-обработки из " + ПутьКФайлуСборкиПроекта + "...");
	Команда.УстановитьСтрокуЗапуска(СтрокаЗапуска);
	КодВозврата = Команда.Исполнить();
	Если КодВозврата=0 Тогда
		Сообщить("Мастер-обработка сформирована в " + ПутьКФайлуМастерОбработки);
	Иначе
		Сообщить("Проблемы при формировании мастер-обработки. Лог: " + ПутьКФайлуЛога);
	КонецЕсли;
	// Сообщить(Команда.ПолучитьВывод());
КонецПроцедуры




Парсер = Новый ПарсерАргументовКоманднойСтроки();
Парсер.ДобавитьИменованныйПараметр("-cfg");
Парсер.ДобавитьИменованныйПараметр("-prj");

ПараметрыЗапуска = Парсер.Разобрать(АргументыКоманднойСтроки);
ФайлНастроек = ПараметрыЗапуска["-cfg"];
ПроектКлюч = ПараметрыЗапуска["-prj"];

ОшибкаЗапуска = Ложь;
Если ПроектКлюч = Неопределено ИЛИ ПустаяСтрока(ПроектКлюч) Тогда
	Сообщить("Не передан ключ проекта.");
	ОшибкаЗапуска = Истина;
КонецЕсли;
Если ФайлНастроек = Неопределено ИЛИ ПустаяСтрока(ФайлНастроек) Тогда
	Сообщить("Не передан файл настроек.");
	ОшибкаЗапуска = Истина;
КонецЕсли;
Если ОшибкаЗапуска Тогда
	Сообщить(Символы.ПС + "Пример запуска: " + Символы.ПС);
	Сообщить("oscript ReleasePrepare.os -cfg <ФайлНастроек> -prj <КлючПроекта>");
	Сообщить("   <ФайлНастроек> - имя json-файла с описанием настроек запуска для проектов");
	Сообщить("   <КлючПроекта> - ключ проекта из файла настроек ");
	Exit(0);
КонецЕсли;

Сообщить(Новый Файл(ТекущийСценарий().Источник).Путь);

// ПроектКлюч = "Test_Release";
ЧтениеJSON = Новый ЧтениеJSON();
ЧтениеJSON.ОткрытьФайл(ФайлНастроек);
НастройкиЗапуска = ПрочитатьJSON(ЧтениеJSON, False);

Если НЕ НастройкиЗапуска.Свойство(ПроектКлюч) Тогда
	Сообщить("В config.json отсутствует описание проекта: " + ПроектКлюч);
	Exit(0);
Иначе
	НастройкиПроекта = НастройкиЗапуска[ПроектКлюч];
КонецЕсли;

ПутьК1С  = НастройкиЗапуска["Programs"]["v83"];

Если НЕ НастройкиПроекта.Свойство("ФайлПроекта") Тогда
	Сообщить("В config.json отсутствует описание пути к файлу обработки: " + ПроектКлюч);
	Exit(0);
Иначе
	ПроектФайл = НастройкиПроекта["ФайлПроекта"];
КонецЕсли;

База1С = НастройкиПроекта["База1С"];
ПользовательИмя = НастройкиПроекта["Пользователь1С"]["Имя"];
ПользовательПароль = НастройкиПроекта["Пользователь1С"]["Пароль"];
КаталогДампа = ВременныеФайлы.СоздатьКаталог(ПроектКлюч);
КаталогРелизов = НастройкиЗапуска["КаталогРелизов"];

Сообщить("================ Параметры запуска ================");
Сообщить("Ключ проекта   : " + ПроектКлюч);
Сообщить("Файл проекта   : " + ПроектФайл);
// Сообщить("Путь к 1С      : " + ПутьК1С);
// Сообщить("Файл базы 1С   : " + База1С);
// Сообщить("Имя польз.     : " + ПользовательИмя);
// Сообщить("Пароль польз.  : " + ПользовательПароль);
Сообщить("Каталог дампа  : " + КаталогДампа);
Сообщить("Каталог релизов: " + КаталогРелизов);
PrintLine("=", 51);

ОбработкуРазобрать(ПроектФайл, КаталогДампа);
ПроектИмя = ПолучитьИмяПроекта(КаталогДампа);
// Сообщить("> Имя проекта - " + ПроектИмя);

ПодготовитьИсходники(КаталогДампа);

ПутьФайлаСборки = ОбъединитьПути(КаталогДампа, ПроектИмя + ".xml");
ПутьМастерСборки = ПолучитьПутьМастерСборки();
ОбработкуСобрать(ПутьФайлаСборки, ПутьМастерСборки);

Сообщить("Процесс завершен.");
