#!/bin/bash

psql -d Adventureworks < rolapSchema.sql
psql -d Adventureworks < rolapPopulate.sql
