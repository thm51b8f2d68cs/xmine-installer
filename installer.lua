xdirdata = { xroot = "/.xmine", xbin = "/bin/", xlib = "/lib/", xdata = "/data/" }

xroot = xdirdata.xroot
xbin = xdirdata.xbin
xlib = xdirdata.xlib
xdata = xdirdata.xdata

function main()
    displayTitle()
    installerWizard(promptUser("[install/uninstall/exit]"))
end

function displayTitle()
    term.clear()
    os.sleep(1)
    print("                 X Mine")
    textutils.slowPrint("=======================================\n")
    os.sleep(1)
end

function promptUser(choices)
    print(choices)
    io.write(">")
    return io.read()
end

function installerWizard(userChoice)
    if (userChoice == "install") then
        getInstallVersion()
        promptRestart()
    elseif (userChoice == "uninstall") then
        uninstall()
        promptRestart()
    elseif (userChoice == "exit") then
        exit()
    else
        print("Please enter an option.")
        installerWizard(promptUser())
    end
end

function getInstallVersion()
    print("\nSelect version.")
    userChoice = promptUser("[master/develop]")
    print("\n")
    if (userChoice == "master") then
        uninstall()
        shell.run("gitget thm51b8f2d68cs xmine master")
        print("\n")
        install()
    elseif (userChoice == "develop") then
        uninstall()
        shell.run("gitget thm51b8f2d68cs xmine develop")
        print("\n")
        install()
    else
        print("Choose an option.")
        getInstallVersion()
    end
end

function install()
    --If a backup exists, remove the current file and replace it with the backup
    if (fs.exists("/.excavations.txt")) then
        fs.delete(xroot .. xdata .. "/.excavations.txt")
        fs.move("/.excavations.txt", xroot .. xdata .. "/.excavations.txt")
    else
        fs.move(xroot .. xdata .. "excavations.txt", xroot .. xdata .. ".excavations.txt")
    end
    fs.move(xroot .. xdata .. "dirdata.txt", "/.dirdata.txt")
    fs.move("getDirData.lua", "/.getDirData.lua")
    fs.delete("README.md")

    dirData = io.open("/.dirdata.txt", "w")
    dataToWrite = textutils.serialize(xdirdata)
    dirData:write(dataToWrite)
    dirData:close()

    textutils.slowPrint("X Mine is now installed.")
    os.sleep(1)
end

function uninstall()
    --If no backup exists and this is not fresh install then backup
    if (not fs.exists("/.excavations.txt") and fs.exists("xmine.lua")) then
        fs.move(xroot .. xdata .. ".excavations.txt", "/.excavations.txt")
    end
    fs.delete(xroot)
    fs.delete(".dirdata.txt")
    fs.delete(".getDirData.lua")
    fs.delete("xmine.lua")
end

function exit()
    return
end

function promptRestart()
    print("\nRestart? [y/n]")
    io.write(">")
    if (io.read() == "y") then
        os.reboot()
    end
end

main()
