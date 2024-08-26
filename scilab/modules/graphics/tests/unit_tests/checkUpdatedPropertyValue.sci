// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

function checkUpdatedPropertyValue(handle, property, expectedValue)
    currentValue = get(handle, property);
    [flag, errmsg] = assert_checkequal(currentValue, expectedValue);
    iTime = 0;
    while (flag == %F & iTime < 20)
        sleep(100);
        iTime = iTime + 1;
        currentValue = get(handle, property);
        [flag, errmsg] = assert_checkequal(currentValue, expectedValue);
    end
    assert_checkequal(currentValue, expectedValue);
endfunction
