package main

import (
    "bufio"
    "encoding/csv"
    "fmt"
    "github.com/fatih/color"
    "io"
    "io/ioutil"
    "log"
    "net/http"
    "os"
    "os/exec"
    "strings"
)

func getOpenTCP() ([]string, error) {
    ips := make([]string, 0)

    out, err := exec.Command("netstat", "-a", "-p", "TCP").Output()
    if err != nil {
        fmt.Println("ERROR: Failed to get open TCP connections")
        return nil, err
    } else {
        ns := string(out)
        for _, line := range strings.Split(ns, "\n") {
            if strings.HasPrefix(line, "  TCP") {
                fields := strings.Fields(strings.TrimSpace(line))
                addr := strings.Split(fields[2], ":")
                ips = append(ips, addr[0])
            }
        }
    }
    return ips, nil
}

func getServers() (map[string]string, error) {
    // get request
    resp, err := http.Get("https://raw.githubusercontent.com/ThreeFx/d3servercheck/master/servers.csv")
    if err != nil {
        log.Println("ERROR: Can't get server list")
        return nil, err
    }

    // read response
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        log.Println("ERROR: Can't read server response")
        return nil, err
    }

    // parse response as csv
    r := csv.NewReader(strings.NewReader(string(body)))
    servers := make(map[string]string)

    header := true
    for {
        res, err := r.Read()

        if err == io.EOF {
            break
        }

        if err != nil {
            log.Println("ERROR: Failed to parse response as csv")
            return nil, err
        }

        if header {  // skip header
            header = false
            continue
        }

        servers[res[0]] = res[1]
    }
    return servers, nil
}

func main() {
    for {
        fmt.Println("Checking TCP connections...")

        servers, serverErr := getServers()
        conns, connsErr := getOpenTCP()

        serverMatch := false
        var serverUnknown string = ""
        if serverErr == nil && connsErr == nil {
            for _, conn := range conns {
                if val, ok := servers[conn]; ok {
                    serverMatch = true
                    if val == "good" {
                        color.Green("%s: Server is good", conn)
                    } else {
                        color.Red("%s: Server is bad", conn)
                    }
                }

                if strings.HasPrefix(conn, "37.244.32.") || strings.HasPrefix(conn, "37.244.33.") {
                    serverUnknown = conn
                }
            }
        }

        if serverUnknown != "" && !serverMatch {
            color.Yellow("%s: No information about current diablo server, please restart your game to switch it", serverUnknown)
        }
        if serverUnknown == "" && !serverMatch {
            color.Cyan("Currently not connected to any diablo server")
        }

        fmt.Print("Press 'Enter' to check again...")
        _, _ = bufio.NewReader(os.Stdin).ReadBytes('\n')
    }
}
