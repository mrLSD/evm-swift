#!/bin/bash

swift test 2>&1 | awk '
/error:/ {
    # Use regular expression to capture required parts
    # Regex Breakdown:
    # ^(.+\/)?([^:]+\.swift):([0-9]+): error: -\[(.*?)\] : expected to equal <([^>]+)>, got <([^>]+)>
    regex = "^(.+\\/)?([^:]+\\.swift):([0-9]+): error: -\\[(.*?)\\] : expected to equal <([^>]+)>, got <([^>]+)>"
    if (match($0, regex, m)) {
        # m[2]: Filename (e.g., AddTests.swift)
        # m[3]: Line number (e.g., 15)
        # m[4]: Test name (e.g., PrimitiveTypesTests.ArithmeticAddSpec overflowAdd, when adding zero to zero, returns zero without overflow)
        # m[5]: Expected value (e.g., FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
        # m[6]: Got value (e.g., 0000000000000000000000000000000000000000000000000000000000000000)
        
        BOLD = "\033[1m"
        GREY = "\033[90m"
        RESET = "\033[0m"

        # Print Filename:LineNumber in Bold
        printf BOLD "%s:%s " RESET, m[2], m[3]

        # Print Test Name in Grey
        printf GREY "%s" RESET "\n", m[4]
        
        # Print expected value with tab
        printf GREY "expect: " RESET
        print m[5]
        
        # Print "got:   ActualValue"
        printf GREY "got:    " RESET
        print m[6]
        print "_________________________________"
    }
}
'
