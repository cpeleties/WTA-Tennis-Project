/* WTA Data from 2011-2022 */
select *
from PortfoiloProject..WTAdata
where winner_name='Elena Rybakina' and loser_name='Ons Jabeur'
order by 1 desc

-- Wimbledon Career Stats by Player (Temp Table)
if OBJECT_ID('WimbledonCareers','U') Is not null 
Drop Table WimbledonCareers

Create Table WimbledonCareers
( 
Date date, player nvarchar(255), opponent nvarchar(255), minutes numeric, breakpoints numeric,breakpointwins numeric,doublefaults numeric, aces numeric, winloss nvarchar(255) 
)

Insert into WimbledonCareers
select tourney_date,winner_name as player,loser_name as opponent,minutes, l_bpFaced as breakpoints, (l_bpFaced-l_bpSaved) as breakpointwins, w_df as doublefaults, w_ace as aces,
CASE 
	when winner_name='Elena Rybakina' then 'Win'
	when winner_name='Ons Jabeur' then 'Win'
	else 'Loss'
	end as winloss
from PortfoiloProject..WTAdata
where (winner_name='Elena Rybakina' or winner_name='Ons Jabeur') and tourney_name='Wimbledon'

Insert into WimbledonCareers
select tourney_date,loser_name as player,winner_name as opponent,minutes, w_bpFaced as breakpoints, (w_bpFaced-w_bpSaved) as breakpointwins,  l_df as doublefaults, l_ace as aces,
CASE 
	when (loser_name='Elena Rybakina' or loser_name='Ons Jabeur')  then 'Loss'
	else 'Win'
	end as winloss
from PortfoiloProject..WTAdata
where (loser_name='Elena Rybakina' or loser_name='Ons Jabeur') and tourney_name='Wimbledon'

delete from WimbledonCareers
where (player='Elena Rybakina' and opponent='Ons Jabeur')
or (opponent='Elena Rybakina' and player='Ons Jabeur') 

select *
from WimbledonCareers

Select player, sum(minutes) as Totalmins,round((sum(breakpointwins)/sum(breakpoints)*100),1) as Breakpoint_Success, round(avg(doublefaults),1) as Avgdoublefaults, round(avg(aces),1) as Avgaces, 
sum(case 
	when winloss='win' then 1 else 0 
		end)*100/count(winloss) as winpercent
from WimbledonCareers
group by player


-- Career Ranking variation
if OBJECT_ID('CareerRank','U') Is not null 
Drop Table CareerRank

Create Table CareerRank
( 
Date date, player nvarchar(255), tourney_name nvarchar(255), wta_rank numeric 
)

Insert into CareerRank
select tourney_date, winner_name as player, tourney_name, winner_rank as wta_rank
from PortfoiloProject..WTAdata
where (winner_name='Elena Rybakina' or winner_name='Ons Jabeur')
Insert into CareerRank
select tourney_date, loser_name as player,tourney_name, loser_rank as wta_rank
from PortfoiloProject..WTAdata
where (loser_name='Elena Rybakina' or loser_name='Ons Jabeur')

select *
from CareerRank
group by Date, player, tourney_name, wta_rank
order by 2,1

-- Wimbledon 2022 Performance
select winner_name, loser_name, round, winner_ioc, loser_ioc, score, winner_rank, loser_rank 
from PortfoiloProject..WTAdata
where year(tourney_date)='2022'
and tourney_name='Wimbledon'
and ((winner_name='Elena Rybakina' or winner_name='Ons Jabeur') or (loser_name='Elena Rybakina' or loser_name='Ons Jabeur'))
order by 1
