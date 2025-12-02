-- Increment/decrement slider value
tell application "System Events"
    set frontApp to first process whose frontmost is true
    if exists window "Colors" of frontApp then
        set colorWindow to window "Colors" of frontApp
        
        -- get the first available splitter group
        set firstSplitter to missing value
        repeat with sg in every splitter group of colorWindow
            set firstSplitter to sg
            exit repeat
        end repeat
        
        if firstSplitter is not missing value then
            
            if exists slider 1 of firstSplitter then
                
                -perform action "AXIncrement" of slider 1 of firstSplitter
                --perform action "AXDecrement" of slider 1 of firstSplitter
                
                return true
                
            end if
            
            return false
            
        end if
        
        return false
        
    end if
    
    return false
end tell

-- Get number of sliders
tell application "System Events"
    set frontApp to first process whose frontmost is true
    if exists window "Colors" of frontApp then
        set colorWindow to window "Colors" of frontApp
        
        -- get the first available splitter group
        set firstSplitter to missing value
        repeat with sg in every splitter group of colorWindow
            set firstSplitter to sg
            exit repeat
        end repeat
        
        if firstSplitter is not missing value then

            return count of sliders of firstSplitter
            
        end if
        
        return 0
        
    end if
    
    return 0
end tell
