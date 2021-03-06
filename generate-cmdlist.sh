#!/bin/sh

if ! echo abc | sed 's/(ab)c/\1/' >/dev/null 2>&1
then
	alias sed='sed -E'
fi

die () {
	echo "$@" >&2
	exit 1
}

command_list () {
	eval "grep -ve '^#' $exclude_programs" <"$1"
}

get_categories () {
	tr ' ' '\012'|
	grep -v '^$' |
	sort |
	uniq
}

category_list () {
	command_list "$1" |
	awk '{ print substr($0, 40) }' |
	get_categories
}

get_synopsis () {
	sed -n '
		/^NAME/,/'"$1"'/h
		${
			x
			s/.*'"$1"' - (.*)/N_("\1")/
			p
		}' "Documentation/$1.txt"
}

define_categories () {
	echo
	echo "/* Command categories */"
	bit=0
	category_list "$1" |
	while read cat
	do
		echo "#define CAT_$cat (1UL << $bit)"
		bit=$(($bit+1))
	done
	test "$bit" -gt 32 && die "Urgh.. too many categories?"
}

define_category_names () {
	echo
	echo "/* Category names */"
	echo "static const char *category_names[] = {"
	bit=0
	category_list "$1" |
	while read cat
	do
		echo "	\"$cat\", /* (1UL << $bit) */"
		bit=$(($bit+1))
	done
	echo "	NULL"
	echo "};"
}

if test -z "$(echo -n)"
then
	alias print='echo -n'
else
	alias print='printf %s'
fi

print_command_list () {
	echo "static struct cmdname_help command_list[] = {"

	command_list "$1" |
	while read cmd rest
	do
		print "	{ \"$cmd\", $(get_synopsis $cmd), 0"
		for cat in $(echo "$rest" | get_categories)
		do
			print " | CAT_$cat"
		done
		echo " },"
	done
	echo "};"
}

exclude_programs=
while test "--exclude-program" = "$1"
do
	shift
	exclude_programs="$exclude_programs -e \"^$1 \""
	shift
done

echo "/* Automatically generated by generate-cmdlist.sh */
struct cmdname_help {
	const char *name;
	const char *help;
	uint32_t category;
};
"
define_categories "$1"
echo
define_category_names "$1"
echo
print_command_list "$1"
