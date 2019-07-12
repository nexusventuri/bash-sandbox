#!/bin/bash

lib="lib/helpers.sh"
source "$lib"

script="other/function_invokation_by_main_source.sh"
echo ""
echo ""
echo "using source"
echo ""
source "$script"
echo ""
echo ""
echo ""
echo ""

echo ""
echo ""
echo "using actual invocation"
echo ""
$script
echo ""
echo ""
echo ""
echo ""

echo ""
echo ""
echo "using $ ( )"
echo ""
echo $($script)
echo ""
echo ""
echo ""
echo ""
