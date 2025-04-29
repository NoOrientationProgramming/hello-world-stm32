#!/bin/sh

find \
	. \
	-type f \
	-name "*.cpp" \
	! -path "./SystemCore/stm32-uart/*" \
	! -path "./SystemCore/SystemDebugging.*" \
| xargs cppcheck \
	--language=c++ \
	--std=c++11 \
	$@

