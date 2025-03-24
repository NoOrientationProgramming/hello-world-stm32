#!/bin/sh

find \
	. \
	-type f \
	-name "*.cpp" \
	! -path "./ProcessingCore/stm32-uart/*" \
| xargs cppcheck \
	--language=c++ \
	--std=c++11 \
	$@

