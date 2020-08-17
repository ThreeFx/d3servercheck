package main

import (
    "encoding/csv"
    "fmt"
    "github.com/fatih/color"
    "io"
    "io/ioutil"
    "log"
    "net/http"
    "os/exec"
    "strings"
    "time"
)

type countdown struct {
    t int
    d int
    h int
    m int
    s int
}

func getTimeRemaining(t time.Time) countdown {
    currentTime := time.Now()
    difference := t.Sub(currentTime)

    total := int(difference.Seconds())
    days := int(total / (60 * 60 * 24))
    hours := int(total / (60 * 60) % 24)
    minutes := int(total/60) % 60
    seconds := int(total % 60)

    return countdown{
        t: total,
        d: days,
        h: hours,
        m: minutes,
        s: seconds,
    }
}

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
        found := false
        if serverErr == nil && connsErr == nil {
            for _, conn := range conns {
                if val, ok := servers[conn]; ok {
                    found = true
                    if val == "good" {
                        color.Green("%s: Server is good", conn)
                    } else {
                        color.Red("%s: Server bad good", conn)
                    }
                }
            }
        }

        if !found {
            fmt.Println("Not connected to any known diablo server, restart game pls")
        }

        next := time.Now().Add(5 * time.Minute)
        for range time.Tick(1 * time.Second) {
            timeRemaining := getTimeRemaining(next)

            if timeRemaining.t <= 0 {
                fmt.Printf("\r")
                break
            }

            fmt.Printf("\rChecking again in: %d:%d", timeRemaining.m, timeRemaining.s)
        }
    }
}