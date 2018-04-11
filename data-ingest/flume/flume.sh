# Flume Notes

# Starting an agent
flume-ng agent 
    -n agentName \
    -c /etc/flume-ng/conf \
    -f /path/to/flume.conf \
    -Dflume.root.logger=INFO,console

# Alternatively, starting an agent
flume-ng agent \
    --name agentName \
    --conf /etc/flume-ng/conf \
    --conf-file /path/to/flume.conf \
    -Dflume.root.logger=INFO,console
    
# Sample flume.conf
#########################################################
myAgent.sources = mySource
myAgent.sinks = mySink
myAgent.channels = myChannel

myAgent.sources.mySource.channels = myChannel
myAgent.sinks.mySink.channel = myChannel

myAgent.sources.mySource.type = netcat
myAgent.sources.mySource.bind = localhost
myAgent.sources.mySource.port = 1234

myAgent.sinks.mySink.type = logger

myAgent.channels.myChannel.type = memory
myAgent.channels.myChannel.capacity = 1024
myAgent.channels.myChannel.transactionCapacity = 100
#########################################################

# To start this sample flume.conf
flume-ng agent -n myAgent -c /etc/flume/conf -f ./flume.conf

#================================================================================================
# FLUME SOURCES
#================================================================================================
# Syslog - creates an event for each string of characters ending in a newline
    ## Required
    <agent>.sources.<source>.type = syslogtcp
    <agent>.sources.<source>.host = 0.0.0.0
    <agent>.sources.<source>.port = 1234
    <agent>.sources.<source>.channels = <channel>

# Netcat - listens on specified port and turns each line of text into an event
    ## Required
    <agent>.sources.<source>.type = netcat
    <agent>.sources.<source>.bind = 0.0.0.0
    <agent>.sources.<source>.port = 1234
    <agent>.sources.<source>.channels = <channel>

# Exec - runs command and sends output over channel
    ## Required
    <agent>.sources.<source>.type = syslog
    <agent>.sources.<source>.command = tail -F /var/log/secure
    <agent>.sources.<source>.channels = <channel>

# Spooldir - watches directory for files 
    ## Required
    <agent>.sources.<source>.type = spooldir
    <agent>.sources.<source>.spoolDir = /some/local/path
    <agent>.sources.<source>.channels = <channel>

# HTTP Source - Accepts events as post or get
    ## Required
    <agent>.sources.<source>.type = http
    <agent>.sources.<source>.port = 1234
    <agent>.sources.<source>.channels = <channel>

#================================================================================================
# FLUME SINKS
#================================================================================================
# Null - discards all events
    ## Required
    <agent>.sinks.<sink>.type = hdfs
    <agent>.sinks.<sink>.channel = <channel>

# Logger - logs events at INFO level
    ## Required
    <agent>.sinks.<sink>.type = hdfs
    <agent>.sinks.<sink>.channel = <channel>

# IRC - relays events to IRC destination
    ## Required
    <agent>.sinks.<sink>.type = irc
    <agent>.sinks.<sink>.hostname = some.irc.domain.com
    <agent>.sinks.<sink>.nick = flume-user
    <agent>.sinks.<sink>.chan = flume-channel
    <agent>.sinks.<sink>.channel = <channel>

# HDFS
    ## Required
    <agent>.sinks.<sink>.type = hdfs
    <agent>.sinks.<sink>.hdfs.path = /some/hdfs/path
    <agent>.sinks.<sink>.channel = <channel>

    ## Optional
    <agent>.sinks.<sink>.codeC = <gzip, bzip2, lzo, lzop, snappy>
    <agent>.sinks.<sink>.fileType = <SequenceFile, DataStream, CompressedStream>
    <agent>.sinks.<sink>.fileSuffix = .txt

# HBaseSink - writes data to HBASE
    ## Required
    <agent>.sinks.<sink>.type = hbase
    <agent>.sinks.<sink>.table = someTable
    <agent>.sinks.<sink>.columnFamily = someColFam
    <agent>.sinks.<sink>.channel = <channel>

#================================================================================================
# FLUME CHANNELS
#================================================================================================
# Memory Channel
    ## Required
    <agent>.channels.<channel>.type = memory

    ## Optional
    <agent>.channels.<channel>.capacity = # of events
    <agent>.channels.<channel>.transactionCapacity = # of events

# File Channel
    ## Required
    <agent>.channels.<channel>.type = file

    ## Optional
    <agent>.channels.<channel>.checkpointDir = /some/path
    <agent>.channels.<channel>.dataDirs = /some/other/path

# JDBC Channel
    ## Required
    <agent>.channels.<channel>.type = jdbc