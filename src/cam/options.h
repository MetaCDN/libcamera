/* SPDX-License-Identifier: GPL-2.0-or-later */
/*
 * Copyright (C) 2019, Google Inc.
 *
 * options.h - cam - Options parsing
 */
#ifndef __CAM_OPTIONS_H__
#define __CAM_OPTIONS_H__

#include <ctype.h>
#include <list>
#include <map>

class KeyValueParser;
class OptionValue;

enum OptionArgument {
	ArgumentNone,
	ArgumentRequired,
	ArgumentOptional,
};

enum OptionType {
	OptionNone,
	OptionInteger,
	OptionString,
	OptionKeyValue,
};

struct Option {
	int opt;
	OptionType type;
	const char *name;
	OptionArgument argument;
	const char *argumentName;
	const char *help;
	KeyValueParser *keyValueParser;

	bool hasShortOption() const { return isalnum(opt); }
	bool hasLongOption() const { return name != nullptr; }
	const char *typeName() const;
};

template<typename T>
class OptionsBase
{
public:
	bool valid() const;
	bool isSet(const T &opt) const;
	const OptionValue &operator[](const T &opt) const;

private:
	friend class KeyValueParser;
	friend class OptionsParser;

	bool parseValue(const T &opt, const Option &option, const char *value);
	void clear();

	std::map<T, OptionValue> values_;
};

class KeyValueParser
{
public:
	class Options : public OptionsBase<std::string>
	{
	};

	bool addOption(const char *name, OptionType type, const char *help,
		       OptionArgument argument = ArgumentNone);

	Options parse(const char *arguments);
	void usage(int indent);

private:
	std::map<std::string, Option> optionsMap_;
};

class OptionValue
{
public:
	OptionValue();
	OptionValue(int value);
	OptionValue(const char *value);
	OptionValue(const std::string &value);
	OptionValue(const KeyValueParser::Options &value);

	OptionType type() const { return type_; }

	operator int() const;
	operator std::string() const;
	operator KeyValueParser::Options() const;

	int toInteger() const;
	std::string toString() const;
	KeyValueParser::Options toKeyValues() const;

private:
	OptionType type_;
	int integer_;
	std::string string_;
	KeyValueParser::Options keyValues_;
};

class OptionsParser
{
public:
	class Options : public OptionsBase<int>
	{
	};

	bool addOption(int opt, OptionType type, const char *help,
		       const char *name = nullptr,
		       OptionArgument argument = ArgumentNone,
		       const char *argumentName = nullptr);
	bool addOption(int opt, KeyValueParser *parser, const char *help,
		       const char *name = nullptr);

	Options parse(int argc, char *argv[]);
	void usage();

private:
	void parseValueError(const Option &option);

	std::list<Option> options_;
	std::map<unsigned int, Option *> optionsMap_;
};

#endif /* __CAM_OPTIONS_H__ */
